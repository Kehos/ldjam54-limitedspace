extends Node

@export var itemScene: PackedScene

@onready var doorActions: RichTextLabel = $TextsContainer/MarginContainer/DoorActionsText
@onready var textContent: RichTextLabel = $TextsContainer/MarginContainer/CurrentActionText

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

# Items propeties
@onready var itemSpawns = $ItemSpawns.get_children()
var spawnPointStatus = []
@onready var itemsContainer: Node = $Items

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
	
func get_dungeon_properties():
	$"/root/GameBuilder".build_game_rooms()
	roomDoors = $"/root/GameBuilder".get_rooms()
	roomItems = $"/root/GameBuilder".get_room_items()
	for i in itemSpawns:
		spawnPointStatus.append(false)
	
func set_current_room_properties():
	currentRoomID = roomDoors[currentRoom]
	currentRoomItems = roomItems[currentRoom]
	spawn_items()
	
func spawn_items():
	# Clean spawn points
	for i in range(0, spawnPointStatus.size()):
		spawnPointStatus[i] = false
	
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
		while spawnPointStatus[randomSpawnPoint]:
			randomSpawnPoint = rng.randi_range(0, itemSpawns.size() - 1)
		spawnPointStatus[randomSpawnPoint] = true
		item.position = Vector2(itemSpawns[randomSpawnPoint].position)
	
func discard_item():
	itemInHand = ""

func _on_canvas_layer_item_picked(item):
	if itemInHand:
		$GameUI.drop_item(itemInHand)
	itemInHand = item

func _on_open_door_button_pressed():
	if itemInHand == currentRoomID:
		discard_item()
		$GameUI/OpenDoorButton.hide()
		if currentRoom != maxRoom:
			$GameUI/NextRoomButton.show()

func _on_next_room_button_pressed():
	currentRoom += 1
	set_current_room_properties()
	$GameUI/NextRoomButton.hide()
	$GameUI/OpenDoorButton.show()

# Door
func _on_player_door_entered():
	doorInteractable = true
	textContent.hide()
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
	else:
		textContent.text = "This does not work here"
	textContent.show()
