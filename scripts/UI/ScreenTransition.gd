extends CanvasLayer

signal screen_covered
signal room_changed

func change_scene():
	$AnimationPlayer.play("SceneChange")
	
func change_room():
	$AnimationPlayer.play("RoomChange")

func emit_screen_covered():
	screen_covered.emit()
