extends KinematicBody2D

const gravityConstant = 400
const speedLimit = 500
const speedFactor = 5
const upDirection = Vector2(0, -1)

var jumping = false

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
	elif Input.is_action_pressed('ui_down'):
		velocity.y = 1000

	move_and_slide(velocity + gravity, upDirection)
	var collision = get_slide_count() > 0
	if collision and is_on_floor():
		gravity.y = gravityConstant
		velocity.y = 0
		jumping = false
	else:
		jumping = true
		gravity.y += 40

func _process(delta):
	if jumping:
		$AnimatedSprite.play("Jump")
	elif Input.is_action_pressed('ui_right'):
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("Walk")
	elif Input.is_action_pressed('ui_left'):
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("Walk")
	else:
		$AnimatedSprite.play("Idle")

