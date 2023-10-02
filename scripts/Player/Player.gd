extends CharacterBody2D

signal door_entered
signal door_exited
signal item_entered
signal item_exited
signal clue_entered
signal clue_exited

const SPEED = 150.0

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
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
