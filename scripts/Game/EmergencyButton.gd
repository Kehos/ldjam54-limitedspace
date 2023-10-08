extends Sprite2D

var texturePath = ResourceLoader.load(str("res://sprites/Door/emergency.png"));
var textureHoverPath = ResourceLoader.load(str("res://sprites/Door/emergency_hover.png"));

func _on_emergency_area_area_entered(_area):
	texture = textureHoverPath

func _on_emergency_area_area_exited(_area):
	texture = texturePath
