extends CanvasLayer

signal credits_back_pressed

func _on_back_buttoon_pressed():
	credits_back_pressed.emit()
