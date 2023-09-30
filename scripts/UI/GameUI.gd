extends CanvasLayer

signal item_picked(item)

@onready var roomLabel = $RoomLabel
@onready var playerLabel = $PlayerLabel
@onready var button1 = $MarginContainer/HBoxContainer/Item1
@onready var button2 = $MarginContainer/HBoxContainer/Item2
@onready var button3 = $MarginContainer/HBoxContainer/Item3

var currentRoom = 0
var buttons = []
var doorType = ""

var pickedItem = ""
var pickedFrom = -1

func set_current_room(roomIndex):
	currentRoom = roomIndex

func set_door_type(type):
	doorType = type
	roomLabel.text = str("Room ", currentRoom, " -> ", doorType)

func set_button_texts(texts):
	buttons = texts
	update_button_texts()
	
func update_button_texts():
	button1.text = buttons[0]
	button2.text = buttons[1]
	button3.text = buttons[2]
	
func update_player_label(item, picked = false):
	playerLabel.text = str("Player holds ", item)
	if picked:
		item_picked.emit(item)

func _on_item_1_pressed():
	pickedItem = buttons[0]
	buttons[0] = ""
	pickedFrom = 0
	update_button_texts()
	update_player_label(pickedItem, true)

func _on_item_2_pressed():
	pickedItem = buttons[1]
	buttons[1] = ""
	pickedFrom = 1
	update_button_texts()
	update_player_label(pickedItem, true)

func _on_item_3_pressed():
	pickedItem = buttons[2]
	buttons[2] = ""
	pickedFrom = 2
	update_button_texts()
	update_player_label(pickedItem, true)
	
func drop_item(item):
	print(str("Player drops ", item, " on position ", pickedFrom))
	buttons[pickedFrom] = item
	update_button_texts()
