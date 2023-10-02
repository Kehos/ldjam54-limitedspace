extends Node

@export var itemScene: PackedScene
@export var clueScene: PackedScene

@onready var textContent: RichTextLabel = $TextsContainer/MarginContainer/CurrentActionText
@onready var doorActions: RichTextLabel = $TextsContainer/MarginContainer/DoorActionsText
@onready var itemActions: RichTextLabel = $TextsContainer/MarginContainer/ItemActionsText
@onready var clueAction: RichTextLabel = $TextsContainer/MarginContainer/ClueActionText
@onready var itemInHandLabel: RichTextLabel = $Inventory/MarginContainer/VBoxContainer/ItemInHandLabel

# Game properties
var roomDoors = []
var roomItems = []
var currentRoom = 0
var maxRoom = 4
var goToNextRoomAsked = false

# Current room properties
var currentRoomItems = []
var currentRoomID: int = -1

# Player properties
var itemInHand = -1
@onready var playerNode = $Player
@onready var playerInitialPosition = $Player.position

# Door properties
var doorInteractable = false
var continueText = "Press (E) to continue"
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

var rng = RandomNumberGenerator.new()

func _ready():
	get_dungeon_properties()
	set_current_room_properties()
	
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
	
func get_dungeon_properties():
	$"/root/GameBuilder".build_game_rooms()
	roomDoors = $"/root/GameBuilder".get_room_doors()
	roomItems = $"/root/GameBuilder".get_room_items()
	roomClues = $"/root/GameBuilder".get_room_clues()
	for i in itemSpawns:
		spawnPointStatus.append(-1)
	
func set_current_room_properties():
	init_door_properties()
	currentRoomID = roomDoors[currentRoom]
	currentRoomItems = roomItems[currentRoom]
	spawn_items()
	spawn_clue()
	
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
	clue.item_index = roomClues[currentRoom]
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
	print("GAME COMPLETE!")

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
	itemInHandLabel.text = Constants.ITEM_NAMES[itemInHand]

func remove_item():
	for i in itemsContainer.get_children():
		if i.item_index == itemHoveredId:
			if itemInHand > -1:
				i.item_index = itemInHand
			else:
				i.hide()
				await get_tree().create_timer(1).timeout
				itemsContainer.remove_child(i)
				i.queue_free()
				
func discard_item():
	itemInHand = -1
	itemInHandLabel.text = ""

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
	textContent.text = Constants.ITEM_CLUE[currentRoomID]
	textContent.show()
