extends CharacterBody2D

const SPEED: float = 150.0

func _physics_process(delta: float):
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var vertical_direction := Input.get_axis("ui_up", "ui_down")
	if vertical_direction:
		velocity.y = vertical_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()