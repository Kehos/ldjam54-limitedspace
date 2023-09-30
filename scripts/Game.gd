extends Node

var maxIndex = 15

# Items
var allItems = []
var currentItems = []

# Rooms properties
var rooms: Array[int] = []
var totalRoomCount = 5
var maxItemPerRoom = 3
var maxKeyItemPerRoom = 2
var roomItems = []
var roomKeyItems: Array[int] = []

var rng = RandomNumberGenerator.new()

func _ready():
	get_items_from_constants()
	
	get_room_items()
	print(currentItems)
	
	get_items_on_rooms()
	print(roomItems)

func get_items_from_constants():
	for item in Constants.AVAILABLE_ITEMS:
		allItems.append(str(item))
	
func get_room_items():
	# Get room item indexes
	for i in range(0, totalRoomCount):
		var randomIndex = rng.randi_range(0, maxIndex - 1)
		while rooms.has(randomIndex):
			randomIndex = rng.randi_range(0, maxIndex - 1)
		rooms.append(randomIndex)
		
	# Get items from room indexes
	for i in rooms:
		var item = Constants.AVAILABLE_ITEMS[i]
		var itemIndex = allItems.find(item)
		allItems.remove_at(itemIndex)
		currentItems.append(item)

func get_items_on_rooms():
	for i in rooms:
		roomItems.append([])
		roomKeyItems.append(0)
		
	for i in range(0, currentItems.size()):
		var randomIndex = rng.randi_range(0, i)
		while check_cant_locate(randomIndex):
			randomIndex = rng.randi_range(0, i)
		
		roomItems[randomIndex].append(currentItems[i])
		roomKeyItems[randomIndex] += 1
		
func check_cant_locate(index):
	return (roomItems[index].size() == maxItemPerRoom) or (roomKeyItems[index] == maxKeyItemPerRoom)
