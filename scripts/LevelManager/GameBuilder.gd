extends Node

var maxIndex = 15

# Items
var allItems: Array[String] = []
var currentItems: Array[String] = []

# Rooms properties
var rooms: Array[int] = []
var totalRoomCount = 5
var maxItemPerRoom = 3
var maxKeyItemPerRoom = 2
var roomItems = []
var roomKeyItems: Array[int] = []

var rng = RandomNumberGenerator.new()

func build_game_rooms():
	get_items_from_constants()
	set_room_items()
	get_items_on_rooms()
	
func get_rooms():
	return currentItems
	
func get_room_items():
	return roomItems

func get_items_from_constants():
	for item in Constants.AVAILABLE_ITEMS:
		allItems.append(str(item))
	
func set_room_items():
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
	# Init items arrays
	for i in rooms:
		roomItems.append([])
		roomKeyItems.append(0)
	
	# Add key items to max room
	for i in range(0, currentItems.size()):
		var randomIndex = rng.randi_range(0, i)
		while check_cant_locate(randomIndex, true):
			randomIndex = rng.randi_range(0, i)
		roomItems[randomIndex].append(currentItems[i])
		roomKeyItems[randomIndex] += 1
		
	print(currentItems)
	print(roomKeyItems)
	print(roomItems)
		
	# Add remaining items to fill rooms
	for i in range(0, allItems.size()):
		var randomIndex = rng.randi_range(0, roomItems.size() - 1)
		while check_cant_locate(randomIndex):
			randomIndex = rng.randi_range(0, roomItems.size() - 1)
		roomItems[randomIndex].append(allItems[i])
		
func check_cant_locate(index, checkKeyItems = false):
	if checkKeyItems:
		var neighbor_full = false
		if index == 0:
			# Next neighbor is full
			var nextIsFull = roomKeyItems[index + 1] == maxKeyItemPerRoom
			# Next and current neighbor are full-1
			var nextAndCurrent = (roomKeyItems[index + 1] == (maxKeyItemPerRoom - 1)) and (roomKeyItems[index] == (maxKeyItemPerRoom - 1))
			neighbor_full = nextIsFull or nextAndCurrent
		elif index == totalRoomCount - 1:
			# Previous neighbor is full
			var prevIsFull = roomKeyItems[index - 1] == maxKeyItemPerRoom
			# Previous and current neighbor are full-1
			var prevAndCurrent = (roomKeyItems[index - 1] == (maxKeyItemPerRoom - 1)) and (roomKeyItems[index] == (maxKeyItemPerRoom - 1))
			neighbor_full = prevIsFull or prevAndCurrent
		else:
			# Previous neighbor is full
			var prevIsFull = roomKeyItems[index - 1] == maxKeyItemPerRoom
			# Next neighbor is full
			var nextIsFull = roomKeyItems[index + 1] == maxKeyItemPerRoom
			# Previous or next neight and current are full -1
			var prevOrNextAndCurrent = (roomKeyItems[index] == (maxKeyItemPerRoom - 1)) and ((roomKeyItems[index - 1] == (maxKeyItemPerRoom - 1)) or (roomKeyItems[index + 1] == (maxKeyItemPerRoom - 1)))
			neighbor_full = prevIsFull or nextIsFull or prevOrNextAndCurrent
		return (roomItems[index].size() == maxItemPerRoom) or (roomKeyItems[index] == maxKeyItemPerRoom) or neighbor_full
	else:
		return roomItems[index].size() == maxItemPerRoom
