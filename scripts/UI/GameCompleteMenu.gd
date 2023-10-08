extends CanvasLayer

func _on_replay_button_pressed():
	$"/root/LevelManager".restart_game()

func _on_main_menu_button_pressed():
	$"/root/LevelManager".go_to_main_menu()
