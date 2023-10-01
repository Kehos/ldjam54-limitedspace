extends CharacterBody2D

signal door_entered
signal door_exited

const SPEED = 150.0

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()

func _on_area_2d_area_entered(area):
	if area.name == Constants.DOOR_AREA_NAME:
		door_entered.emit()

func _on_area_2d_area_exited(area):
	if area.name == Constants.DOOR_AREA_NAME:
		door_exited.emit()
