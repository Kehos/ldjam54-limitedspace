extends CanvasLayer

signal options_back_pressed

func _on_back_buttoon_pressed():
	options_back_pressed.emit()
