extends Node

var maxIndex = 15

# Rooms properties
var rooms: Array[int] = []
var totalRoomCount = 5
var maxItemPerRoom = 3
var maxKeyItemPerRoom = 2
var roomItems = []

var rng = RandomNumberGenerator.new()

func _ready():
	get_room_indexes()
	print(rooms)
	get_items_on_rooms()
	print(roomItems)
	
func get_room_indexes():
	for i in range(0, totalRoomCount):
		var randomIndex = rng.randi_range(0, maxIndex)
		while rooms.has(randomIndex):
			randomIndex = rng.randi_range(0, maxIndex)
		rooms.append(randomIndex)

func get_items_on_rooms():
	for index in rooms:
		roomItems.append([])
