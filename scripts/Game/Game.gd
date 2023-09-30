extends Node

# Game properties
var roomDoors = []
var roomItems = []
var currentRoom = 0

# Current room properties
var currentRoomItems = []
var currentRoomID = ""

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
	$GameUI.set_door_type(currentRoomID)
	$GameUI.set_button_texts(currentRoomItems)
