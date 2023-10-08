extends CanvasLayer

signal tutorial_back_pressed

func _on_back_buttoon_pressed():
	tutorial_back_pressed.emit()
