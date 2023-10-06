extends Sprite2D

@export var item_index: int

var texturePath = ""
var textureHoverPath = ""

func _ready():
	set_item_texture()
	
func set_item_id(id):
	item_index = id
	set_item_texture()
	
func set_item_texture():
	texturePath = ResourceLoader.load(str("res://sprites/Items/", Constants.AVAILABLE_ITEMS[item_index], ".png"))
	textureHoverPath = ResourceLoader.load(str("res://sprites/Items/", Constants.AVAILABLE_ITEMS[item_index], "_hover.png"))
	texture = texturePath

func _on_item_area_area_entered(_area):
	texture = textureHoverPath

func _on_item_area_area_exited(_area):
	texture = texturePath
