extends CanvasLayer

@onready var roomLabel = $MarginContainer/RoomLabel
@onready var button1 = $MarginContainer/HBoxContainer/Item1
@onready var button2 = $MarginContainer/HBoxContainer/Item2
@onready var button3 = $MarginContainer/HBoxContainer/Item3

var currentRoom = 0
var buttons = []
var doorType = ""

func set_current_room(roomIndex):
	currentRoom = roomIndex

func set_door_type(type):
	doorType = type
	roomLabel.text = str("Room ", currentRoom, " -> ", doorType)

func set_button_texts(texts):
	buttons = texts
	button1.text = texts[0]
	button2.text = texts[1]
	button3.text = texts[2]
