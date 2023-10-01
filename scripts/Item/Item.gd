extends Sprite2D

signal show_description(description)

@export var item_index: int

var itemDescription = ""

func _ready():
	itemDescription = Constants.ITEM_DESCRIPTION[item_index]
	$Label.text = Constants.ITEM_NAMES[item_index]

func _on_area_2d_mouse_entered():
	$Label.show()
	show_description.emit(itemDescription)

func _on_area_2d_mouse_exited():
	$Label.hide()
