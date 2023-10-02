extends Node

var gameScenePath = "res://scenes/Game/Game.tscn"
var mainMenuScenePath = "res://scenes/UI/MainMenu.tscn"
var gameCompleteMenuScenePath = "res://scenes/UI/GameCompleteMenu.tscn"

func start_game():
	change_scene_by_path(gameScenePath)

func restart_level():
	start_game()

func go_to_main_menu():
	change_scene_by_path(mainMenuScenePath)
	
func finish_game():
	change_scene_by_path(gameCompleteMenuScenePath)

func change_scene_by_path(scenePath):
	$"/root/SceneTransitionManager".transition_to_scene(scenePath)
