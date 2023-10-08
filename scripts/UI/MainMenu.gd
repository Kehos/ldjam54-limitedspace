extends CanvasLayer

var creditsMenuScene = preload("res://scenes/UI/CreditsMenu.tscn")
var optionsMenuScene = preload("res://scenes/UI/OptionsMenu.tscn")
var tutorialMenuScene = preload("res://scenes/UI/TutorialMenu.tscn")

func _on_play_button_pressed():
	$"/root/LevelManager".start_game()

func _on_options_button_pressed():
	var optionsMenuInstance = optionsMenuScene.instantiate()
	add_child(optionsMenuInstance)
	optionsMenuInstance.options_back_pressed.connect(on_back.bind("options"))
	$MarginContainer.visible = false

func _on_credits_button_pressed():
	var creditsMenuInstance = creditsMenuScene.instantiate()
	add_child(creditsMenuInstance)
	creditsMenuInstance.credits_back_pressed.connect(on_back.bind("credits"))
	$MarginContainer.visible = false
	
func _on_tutorial_button_pressed():
	var tutorialMenuInstance = tutorialMenuScene.instantiate()
	add_child(tutorialMenuInstance)
	tutorialMenuInstance.tutorial_back_pressed.connect(on_back.bind("tutorial"))
	$MarginContainer.visible = false

func _on_exit_button_pressed():
	get_tree().quit()
	
func on_back(scene):
	if scene == "credits":
		$CreditsMenu.visible = false
	elif scene == "options":
		$OptionsMenu.visible = false
	elif scene == "tutorial":
		$TutorialMenu.visible = false
	$MarginContainer.visible = true
	
	await get_tree().create_timer(0.2).timeout
	if scene == "credits":
		$CreditsMenu.queue_free()
	elif scene == "options":
		$OptionsMenu.queue_free()
	elif scene == "tutorial":
		$TutorialMenu.queue_free()
