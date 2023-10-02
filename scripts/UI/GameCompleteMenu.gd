extends CanvasLayer

func _ready():
	get_tree().paused = true
	
func unpause():
	$MarginContainer.hide()
	await get_tree().create_timer(0.2).timeout
	queue_free()
	get_tree().paused = false

func _on_replay_button_pressed():
	$"/root/LevelManager".restart_game()
	unpause()

func _on_main_menu_button_pressed():
	$"/root/LevelManager".go_to_main_menu()
	unpause()
