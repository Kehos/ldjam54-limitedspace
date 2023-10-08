extends Node

var screenTransitionScene = preload("res://scenes/UI/ScreenTransition.tscn")

func transition_to_scene(scene_path):
	for button in get_tree().get_nodes_in_group("ui_button"):
		button.disabled = true
		
	await get_tree().create_timer(0.2).timeout
	var screenTransition = screenTransitionScene.instantiate()
	add_child(screenTransition)
	screenTransition.change_scene()
	
	await screenTransition.screen_covered
	get_tree().change_scene_to_file(scene_path)
	
func transition_to_room():
	await get_tree().create_timer(0.2).timeout
	var screenTransition = screenTransitionScene.instantiate()
	add_child(screenTransition)
	screenTransition.change_room()
	
