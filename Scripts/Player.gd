extends KinematicBody2D

const gravityConstant = 400
const speedLimit = 500
const speedFactor = 5

var velocity = Vector2()
var gravity = Vector2(0, gravityConstant)

func _physics_process(delta):

	if Input.is_action_pressed('ui_right'):
		velocity.x += (speedLimit - velocity.x) / speedFactor
	elif Input.is_action_pressed('ui_left'):
		velocity.x -= (speedLimit + velocity.x) / speedFactor
	else:
		velocity.x = (velocity.x / speedFactor)
		if velocity.x < 1:
			velocity.x = 0

	if Input.is_action_pressed('ui_up'):
		velocity.y = -1000

	var collision = move_and_slide(velocity)

	var gravityCollision = move_and_collide(gravity * delta)
	if gravityCollision:
		gravity.y = gravityConstant
		velocity.y = 0
	else:
		gravity.y += 40
