extends KinematicBody2D

const gravityConstant = 400
const speedLimit = 500
const speedFactor = 5
const upDirection = Vector2(0, -1)
const floorMaxAngle = 0.8

var jumping = false
var velocity = Vector2()
var gravity = Vector2(0, gravityConstant)

func _physics_process(_delta):
	var left = Input.is_action_pressed('ui_left')
	var right = Input.is_action_pressed('ui_right')
	var up = Input.is_action_pressed('ui_up')
	
	if right:
		velocity.x += (speedLimit - velocity.x) / speedFactor
	elif left:
		velocity.x -= (speedLimit + velocity.x) / speedFactor
	else:
		velocity.x = (velocity.x / speedFactor)
		if velocity.x < 1:
			velocity.x = 0

	if up:
		velocity.y = -1000

	# move_and_slide(
	#	velocity vector, up direction, slide on slopes?,
	#	maximum number of bounces per calculation,
	#	maximum angle to count as floor in radians,
	#	infinite inertia?
	# )
	var movement = move_and_slide(velocity + gravity, upDirection, true, 4, floorMaxAngle, true)
	var posLabel = get_node('/root/Game/PositionLabel')
	posLabel.text = str(round(movement.x)) + ':' + str(round(movement.y))
	var collision = get_slide_count() > 0
	if collision and is_on_floor():
		gravity.y = gravityConstant
		velocity.y = 0
		jumping = false
	else:
		jumping = true
		gravity.y += 40

func _process(_delta):
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
