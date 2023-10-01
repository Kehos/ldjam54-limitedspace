extends Node

@export var itemScene: PackedScene

@onready var textContent: RichTextLabel = $TextsContainer/MarginContainer/CurrentActionText
@onready var doorActions: RichTextLabel = $TextsContainer/MarginContainer/DoorActionsText
@onready var itemActions: RichTextLabel = $TextsContainer/MarginContainer/ItemActionsText

# Game properties
var roomDoors = []
var roomItems = []
var currentRoom = 0
var maxRoom = 4

# Current room properties
var currentRoomItems = []
var currentRoomID: int = -1

# Player properties
var itemInHand = -1

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

var rng = RandomNumberGenerator.new()

func _ready():
	get_dungeon_properties()
	set_current_room_properties()
	
func _process(_delta):
	if doorInteractable:
		if Input.is_action_just_pressed("observe"):
			observe_door()
		if Input.is_action_just_pressed("interact"):
			interact_door()
			
	if itemInteractable:
		if Input.is_action_just_pressed("observe"):
			observe_item()
		if Input.is_action_just_pressed("interact"):
			pick_item()
	
func get_dungeon_properties():
	$"/root/GameBuilder".build_game_rooms()
	roomDoors = $"/root/GameBuilder".get_rooms()
	roomItems = $"/root/GameBuilder".get_room_items()
	for i in itemSpawns:
		spawnPointStatus.append(-1)
	
func set_current_room_properties():
	currentRoomID = roomDoors[currentRoom]
	currentRoomItems = roomItems[currentRoom]
	spawn_items()
	
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
	
func discard_item():
	itemInHand = ""

# Door
func _on_player_door_entered():
	doorInteractable = true
	textContent.hide()
	itemActions.hide()
	doorActions.show()

func _on_player_door_exited():
	doorInteractable = false
	doorActions.hide()
	
func observe_door():
	doorActions.hide()
	textContent.text = Constants.DOOR_TEXT[currentRoomID]
	textContent.show()

func interact_door():
	doorActions.hide()
	if itemInHand < 0:
		textContent.text = "You need something to interact with the door"
	elif itemInHand == currentRoomID:
		textContent.text = Constants.DOOR_ACTION[currentRoomID]
		doorIsOpen = true
	else:
		textContent.text = "This does not work here"
	textContent.show()

# Item
func _on_player_item_entered(id):
	itemHoveredId = id
	itemInteractable = true
	textContent.hide()
	doorActions.hide()
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
	
	# Pick item
	itemInHand = itemHoveredId
	itemHoveredId = -1
	itemInteractable = false
	textContent.show()
	textContent.text = str("You picked ", Constants.ITEM_NAMES[itemInHand])

func remove_item():
	for i in itemsContainer.get_children():
		if i.item_index == itemHoveredId:
			if itemInHand > -1:
				i.item_index = itemInHand
				print(str("You dropped ", Constants.ITEM_NAMES[i.item_index]))
			else:
				i.hide()
