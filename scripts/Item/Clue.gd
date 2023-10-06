extends Sprite2D

@export var clue_index: int

var texturePath = ResourceLoader.load(str("res://sprites/Clues/clue.png"));
var textureHoverPath = ResourceLoader.load(str("res://sprites/Clues/clue_hover.png"));

func _on_clue_area_area_entered(_area):
	texture = textureHoverPath

func _on_clue_area_area_exited(_area):
	texture = texturePath
