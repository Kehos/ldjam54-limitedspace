extends Node

# Game properties
var roomDoors: Array[String] = []
var roomItems: Array = []

func _ready():
	$"/root/GameBuilder".build_game_rooms()
	roomDoors = $"/root/GameBuilder".get_rooms()
	roomItems = $"/root/GameBuilder".get_room_items()
	
	print(roomDoors)
	print(roomItems)
