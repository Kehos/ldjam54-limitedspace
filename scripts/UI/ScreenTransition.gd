extends CanvasLayer

signal screen_covered

func emit_screen_covered():
	screen_covered.emit()
