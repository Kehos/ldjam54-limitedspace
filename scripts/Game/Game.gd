extends Node

# Game properties
var roomDoors = []
var roomItems = []
var currentRoom = 0
var maxRoom = 4

# Current room properties
var currentRoomItems = []
var currentRoomID = ""

# Player properties
var itemInHand = "GRENADE"

func _ready():
	get_dungeon_properties()
	set_current_room_properties()
	
func get_dungeon_properties():
	$"/root/GameBuilder".build_game_rooms()
	roomDoors = $"/root/GameBuilder".get_rooms()
	roomItems = $"/root/GameBuilder".get_room_items()
	
func set_current_room_properties():
	currentRoomID = roomDoors[currentRoom]
	currentRoomItems = roomItems[currentRoom]
	set_game_UI()
	
func set_game_UI():
	$GameUI.set_current_room(currentRoom)
	$GameUI.update_player_label(itemInHand)
	$GameUI.set_door_type(currentRoomID)
	$GameUI.set_button_texts(currentRoomItems)
	
func discard_item():
	itemInHand = ""

func _on_canvas_layer_item_picked(item):
	if itemInHand:
		$GameUI.drop_item(itemInHand)
	itemInHand = item

func _on_open_door_button_pressed():
	if itemInHand == currentRoomID:
		discard_item()
		if currentRoom != maxRoom:
			$GameUI/NextRoomButton.show()

func _on_next_room_button_pressed():
	currentRoom += 1
	set_current_room_properties()
	$GameUI/NextRoomButton.hide()
