extends CanvasLayer

var optionsMenuScene = preload("res://scenes/UI/OptionsMenu.tscn")

func _ready():
	get_tree().paused = true
	
func unpause(queueFree = true):
	if queueFree:
		$MarginContainer.hide()
		await get_tree().create_timer(0.2).timeout
		queue_free()
	get_tree().paused = false

func _on_resume_button_pressed():
	unpause()

func _on_options_button_pressed():
	var optionsMenuInstance = optionsMenuScene.instantiate()
	add_child(optionsMenuInstance)
	optionsMenuInstance.options_back_pressed.connect(options_back_pressed)
	$MarginContainer.hide()

func _on_main_menu_button_pressed():
	$"/root/LevelManager".go_to_main_menu()
	unpause(false)
	
func options_back_pressed():
	$OptionsMenu.hide()
	$MarginContainer.show()
	await get_tree().create_timer(0.2).timeout
	$OptionsMenu.queue_free()
