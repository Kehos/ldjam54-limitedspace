extends CharacterBody2D

signal door_entered
signal door_exited
signal item_entered
signal item_exited
signal clue_entered
signal clue_exited

const SPEED = 100.0

var canMove = false

func _physics_process(_delta):
	if canMove:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * SPEED
		
	if velocity == Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("Idle")
	else:
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Idle/blend_position", velocity)
		$AnimationTree.set("parameters/Walk/blend_position", velocity)
		move_and_slide()

func _on_area_2d_area_entered(area):
	if area.name == Constants.DOOR_AREA_NAME:
		door_entered.emit()
	if area.name == Constants.ITEM_AREA_NAME:
		item_entered.emit(area.get_parent().item_index)
	if area.name == Constants.CLUE_AREA_NAME:
		clue_entered.emit()

func _on_area_2d_area_exited(area):
	if area.name == Constants.DOOR_AREA_NAME:
		door_exited.emit()
	if area.name == Constants.ITEM_AREA_NAME:
		item_exited.emit()
	if area.name == Constants.CLUE_AREA_NAME:
		clue_exited.emit()
		
func toggle_player_movement():
	canMove = not canMove
