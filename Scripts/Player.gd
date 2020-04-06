extends KinematicBody2D

const gravity = 100
const acceleration = 50
const speedLimit = 500
const fallingSpeedLimit = 1200

var jumping = true

var input = Vector2(0, 0)
var velocity = Vector2(0, 0)
#var gravity = Vector2(0, gravityConstant)

func _physics_process(_delta):
	# Map inputs to velocity
	var left = Input.is_action_pressed('ui_left')
	var right = Input.is_action_pressed('ui_right')
	var up = Input.is_action_pressed('ui_up')
	var down = Input.is_action_pressed('ui_down')

	input.x = 0
	if right:
		input.x += 1
	elif left:
		input.x -= 1

	if left or right:
		velocity.x += input.x * acceleration
		if velocity.x > speedLimit:
			velocity.x = speedLimit
		elif velocity.x < -speedLimit:
			velocity.x = -speedLimit
	else:
		velocity.x -= velocity.x / (acceleration * 0.1)

	if up:
		if not jumping:
			velocity.y -= 1500

	#Map gravity to velocity

	if jumping:
		velocity.y += gravity
	else:
		velocity.y = gravity
	
	if velocity.y > fallingSpeedLimit:
		velocity.y = fallingSpeedLimit

	# Move

	# move_and_slide(
	#	velocity vector, up direction, slide on slopes?,
	#	maximum number of bounces per calculation,
	#	maximum angle to count as floor in radians,
	#	infinite inertia?
	# )
	var movement = move_and_slide(velocity, Vector2(0, -1), true, 2, 0.8, true)

#	if right:
#		velocity.x += (speedLimit - velocity.x) / speedFactor
#	elif left:
#		velocity.x -= (speedLimit + velocity.x) / speedFactor
#	else:
#		velocity.x = (velocity.x / speedFactor)
#		if velocity.x < 1:
#			velocity.x = 0

#	if up:
#		velocity.y = -1500

	# move_and_slide(
	#	velocity vector, up direction, slide on slopes?,
	#	maximum number of bounces per calculation,
	#	maximum angle to count as floor in radians,
	#	infinite inertia?
	# )
#	var movement = move_and_slide(velocity + gravity, Vector2(0, -1), true, 2, 0.8, true)
	$Camera2D/DebugLabel.text = 'x: ' + str(round(movement.x)) + '\n' + \
								'y: ' + str(round(movement.y))

	var collision = get_slide_count() > 0
	if collision:
		jumping = false
	else:
		jumping = true

func _process(_delta):
	if Input.is_action_pressed('ui_reset'):
		get_tree().reload_current_scene()

	var left = Input.is_action_pressed('ui_left')
	var right = Input.is_action_pressed('ui_right')
	var down = Input.is_action_pressed('ui_down')

	if left:
		$AnimatedSprite.flip_h = true
	elif right:
		$AnimatedSprite.flip_h = false

	$AnimatedSprite.offset.y = 0

	if jumping:
		$AnimatedSprite.play("Jump")
	elif right || left:
		$AnimatedSprite.play("Walk")
	elif down:
		$AnimatedSprite.play("Duck")
		$AnimatedSprite.offset.y = 22
	else:
		$AnimatedSprite.play("Idle")
