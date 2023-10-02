extends Node

var maxIndex = 15

# Items
var allItems = []
var roomDoors = []

# Rooms properties
var rooms = []
var totalRoomCount = 5
var maxItemPerRoom = 3
var maxKeyItemPerRoom = 2
var roomItems = []
var roomKeyItems = []

# Clues
var roomClues = []

var rng = RandomNumberGenerator.new()

func build_game_rooms():
	init_all()
	get_items_from_constants()
	set_room_items()
	set_items_on_rooms()
	set_room_clues()
	assign_remaining_items()
	
func init_all():
	allItems = []
	roomDoors = []
	rooms = []
	roomItems = []
	roomKeyItems = []
	roomClues = []
	
func get_room_doors():
	return roomDoors
	
func get_room_items():
	return roomItems
	
func get_room_clues():
	return roomClues

func get_items_from_constants():
	for index in range(0, Constants.AVAILABLE_ITEMS.size()):
		allItems.append(index)
	
func set_room_items():
	# Get room item indexes
	for i in range(0, totalRoomCount):
		var randomIndex = rng.randi_range(0, maxIndex - 1)
		while rooms.has(randomIndex):
			randomIndex = rng.randi_range(0, maxIndex - 1)
		rooms.append(randomIndex)
		
	# Get items from room indexes
	for i in rooms:
		var itemIndex = allItems.find(i)
		allItems.remove_at(itemIndex)
		roomDoors.append(i)

func set_items_on_rooms():
	# Init items arrays
	for i in rooms:
		roomItems.append([])
		roomKeyItems.append(0)
	
	# Add key items to max room
	for i in range(0, rooms.size()):
		var randomIndex = rng.randi_range(0, i)
		while check_cant_locate(randomIndex, true):
			randomIndex = rng.randi_range(0, i)
		roomItems[randomIndex].append(rooms[i])
		roomKeyItems[randomIndex] += 1
		
func set_room_clues():
	# Get clue indexes
	for i in range(0, roomItems.size()):
		var room = roomItems[i]
		for j in range(0, room.size()):
			if room[j] != roomDoors[0]:
				roomClues.append(room[j])
		
func assign_remaining_items():
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
			neighbor_full = roomKeyItems[index + 1] == maxKeyItemPerRoom
		elif index == totalRoomCount - 1:
			neighbor_full = roomKeyItems[index] == 1
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
