extends Sprite2D

@export var item_index: int

func _ready():
	$Label.text = Constants.ITEM_NAMES[item_index]
