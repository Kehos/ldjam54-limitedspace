extends Node

@export var itemScene: PackedScene
@export var clueScene: PackedScene

var pauseMenuScene = preload("res://scenes/UI/PauseMenu.tscn")

@onready var textContent: RichTextLabel = $TextsContainer/MarginContainer/CurrentActionText
@onready var doorActions: RichTextLabel = $TextsContainer/MarginContainer/DoorActionsText
@onready var itemActions: RichTextLabel = $TextsContainer/MarginContainer/ItemActionsText
@onready var clueAction: RichTextLabel = $TextsContainer/MarginContainer/ClueActionText
@onready var emergencyActions: RichTextLabel = $TextsContainer/MarginContainer/EmergencyActionsText
@onready var inventoryItem: Sprite2D = $InventoryItem

# Game properties
var roomDoors = []
var roomItems = []
var currentRoom = 0
var maxRoom = 5
var goToNextRoomAsked = false
@onready var roomIDLabel: RichTextLabel = $Inventory/MarginContainer/VBoxContainer/RoomIDLabel

# Current room properties
var currentRoomItems = []
var currentRoomID: int = -1

# Player properties
var itemInHand = -1
@onready var playerNode = $Player
@onready var playerInitialPosition = $Player.position

# Door properties
var doorInteractable = false
var doorIsOpen = false

# Items propeties
@onready var itemSpawns = $ItemSpawns.get_children()
var spawnPointStatus = []
@onready var itemsContainer: Node = $Items
var itemHoveredId = -1
var itemInteractable = false

# Clues properties
var roomClues = []
@onready var clueSpawns = $ClueSpawns.get_children()
@onready var cluesContainer: Node = $Clues
var clueInteractable = false
var cluePrefix = "A piece of paper, it displays ";

# Emergency properties
var emergencyInteractable = false
var finishGameAsked = false

var rng = RandomNumberGenerator.new()

func _ready():
	get_dungeon_properties()
	set_current_room_properties()
	toggle_interactions()
	
func _process(_delta):
	if doorInteractable:
		if goToNextRoomAsked:
			if Input.is_action_just_pressed("interact"):
				go_to_next_room()
		else:
			if Input.is_action_just_pressed("observe"):
				observe_door()
			if Input.is_action_just_pressed("interact"):
				interact_door()
			
	if itemInteractable:
		if Input.is_action_just_pressed("observe"):
			observe_item()
		if Input.is_action_just_pressed("interact"):
			pick_item()
			
	if clueInteractable:
		if Input.is_action_just_pressed("observe"):
			observe_clue()
			
	if emergencyInteractable:
		if finishGameAsked:
			if Input.is_action_just_pressed("interact"):
				finish_game()
		else:
			if Input.is_action_just_pressed("observe"):
				observe_emergency()
			if Input.is_action_just_pressed("interact"):
				interact_emergency()
			
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pauseInstance = pauseMenuScene.instantiate()
		pauseInstance.game_unpaused.connect(on_game_unpaused)
		add_child(pauseInstance)
		toggle_interactions()
		
func on_game_unpaused():
	toggle_interactions()
	
func get_dungeon_properties():
	$"/root/GameBuilder".build_game_rooms()
	roomDoors = $"/root/GameBuilder".get_room_doors()
	roomItems = $"/root/GameBuilder".get_room_items()
	roomClues = $"/root/GameBuilder".get_room_clues()
	for i in itemSpawns:
		spawnPointStatus.append(-1)
	
func set_current_room_properties():
	roomIDLabel.text = str("Room ", currentRoom)
	init_door_properties()
	currentRoomID = roomDoors[currentRoom]
	currentRoomItems = roomItems[currentRoom]
	spawn_items()
	spawn_clue()
	
func toggle_interactions():
	playerNode.toggle_player_movement()
	
func init_door_properties():
	doorInteractable = false
	doorIsOpen = false
	
func spawn_items():
	# Clean spawn points
	for i in range(0, spawnPointStatus.size()):
		spawnPointStatus[i] = -1
	
	# Delete all remaining items
	for item in itemsContainer.get_children():
		itemsContainer.remove_child(item)
		item.queue_free()
	
	# Spawn current room items
	for i in currentRoomItems:
		var item = itemScene.instantiate()
		item.item_index = i
		itemsContainer.add_child(item)
		
		# Assign items to random spawn points
		var randomSpawnPoint = rng.randi_range(0, itemSpawns.size() - 1)
		while spawnPointStatus[randomSpawnPoint] > -1:
			randomSpawnPoint = rng.randi_range(0, itemSpawns.size() - 1)
		spawnPointStatus[randomSpawnPoint] = i
		item.position = Vector2(itemSpawns[randomSpawnPoint].position)
		
func spawn_clue():
	# Delete current clue
	for item in cluesContainer.get_children():
		cluesContainer.remove_child(item)
		item.queue_free()

	# Spawn clue
	var clue = clueScene.instantiate()
	if currentRoom < maxRoom - 1:
		clue.clue_index = roomClues[currentRoom]
		cluesContainer.add_child(clue)
	
	# Assign clue to random spawn point
	var randomSpawnPoint = rng.randi_range(0, clueSpawns.size() - 1)
	clue.position = Vector2(clueSpawns[randomSpawnPoint].position)
		
func go_to_next_room():
	currentRoom += 1
	if currentRoom == maxRoom:
		game_complete()
	else:
		set_current_room_properties()
		playerNode.position = Vector2(playerInitialPosition)
		
func game_complete():
	toggle_interactions()
	$"/root/LevelManager".finish_game()

# Door
func _on_player_door_entered():
	doorInteractable = true
	textContent.hide()
	itemActions.hide()
	clueAction.hide()
	doorActions.show()

func _on_player_door_exited():
	doorInteractable = false
	doorActions.hide()
	textContent.hide()
	goToNextRoomAsked = false
	
func observe_door():
	doorActions.hide()
	if doorIsOpen:
		textContent.text = "The door is open"
	else:
		textContent.text = Constants.DOOR_TEXT[currentRoomID]
	textContent.show()

func interact_door():
	doorActions.hide()
	
	if doorIsOpen:
		goToNextRoomAsked = true
		if (currentRoom + 1) == maxRoom:
			textContent.text = "Go through the door? (E)"
		else:
			textContent.text = "Go to next room? (E)"
		textContent.show()
	else:
		if itemInHand < 0:
			textContent.text = "You need something to interact with the door"
		elif itemInHand == currentRoomID:
			textContent.text = Constants.DOOR_ACTION[currentRoomID]
			doorIsOpen = true
			discard_item()
		else:
			textContent.text = "This does not work here"
		textContent.show()

# Item
func _on_player_item_entered(id):
	itemHoveredId = id
	itemInteractable = true
	textContent.hide()
	doorActions.hide()
	clueAction.hide()
	itemActions.show()

func _on_player_item_exited():
	itemHoveredId = -1
	itemInteractable = false
	itemActions.hide()
	textContent.hide()
	
func observe_item():
	itemActions.hide()
	textContent.text = Constants.ITEM_DESCRIPTION[itemHoveredId]
	textContent.show()
	
func pick_item():
	itemActions.hide()
	
	# Remove item and drop if had one in hand
	remove_item()
	
	# Update item properties
	if itemInHand > -1:
		textContent.text = str("You dropped ", Constants.ITEM_NAMES[itemInHand], ". You picked ", Constants.ITEM_NAMES[itemHoveredId])
		var itemWasInHand = itemInHand
		itemInHand = itemHoveredId
		itemHoveredId = itemWasInHand
	else:
		textContent.text = str("You picked ", Constants.ITEM_NAMES[itemHoveredId])
		itemInHand = itemHoveredId
		itemHoveredId = -1
		itemInteractable = false
	textContent.show()
	set_inventory_item(itemInHand)
	
func set_inventory_item(itemId):
	inventoryItem.texture = ResourceLoader.load(str("res://sprites/Items/", Constants.AVAILABLE_ITEMS[itemId], ".png"))

func remove_item():
	for i in itemsContainer.get_children():
		if i.item_index == itemHoveredId:
			if itemInHand > -1:
				i.set_item_id(itemInHand)
			else:
				i.hide()
				await get_tree().create_timer(1).timeout
				itemsContainer.remove_child(i)
				i.queue_free()
				
func discard_item():
	itemInHand = -1
	inventoryItem.texture = null

# Clues
func _on_player_clue_entered():
	clueInteractable = true
	textContent.hide()
	doorActions.hide()
	itemActions.hide()
	clueAction.show()

func _on_player_clue_exited():
	clueInteractable = false
	clueAction.hide()
	textContent.hide()

func observe_clue():
	clueAction.hide()
	textContent.text = str(cluePrefix, Constants.ITEM_CLUE[roomClues[currentRoom]])
	textContent.show()

# Emergency button
func _on_player_emergency_entered():
	emergencyInteractable = true
	textContent.hide()
	doorActions.hide()
	itemActions.hide()
	clueAction.hide()
	emergencyActions.show()

func _on_player_emergency_exited():
	finishGameAsked = false
	emergencyInteractable = false
	emergencyActions.hide()
	textContent.hide()
	
func observe_emergency():
	emergencyActions.hide()
	textContent.text = "A red button on the wall"
	textContent.show()
	
func interact_emergency():
	emergencyActions.hide()
	finishGameAsked = true
	textContent.text = check_current_room_completable()
	textContent.show()
	
func check_current_room_completable():
	var buttonText = "Are you sure you want to press the button?"
	var canContinue = false
	
	# Check if items on the floor can open the door
	for i in itemsContainer.get_children():
		if i.item_index == currentRoomID:
			buttonText = str(buttonText, " Make sure you checked all you can do.")
			canContinue = true
	
	# Check if item in hand can open the door
	if not canContinue and itemInHand == currentRoomID:
		buttonText = str(buttonText, " Make sure you checked all you can do.")
	
	return str(buttonText, " If you press the button, you will lose the game.")
	
func finish_game():
	toggle_interactions()
	$"/root/LevelManager".finish_game(true)
