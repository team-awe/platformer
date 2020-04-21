extends KinematicBody2D

const gravity = 2000
const acceleration = 3000
const jumpPower = 500
const speedLimit = 700
const fallingSpeedLimit = 2000

var grounded = false

var input = Vector2(0, 0)
var velocity = Vector2(0, 1)

func _physics_process(delta):
	var left = Input.is_action_pressed('ui_left')
	var right = Input.is_action_pressed('ui_right')
	var up = Input.is_action_pressed('ui_up')
	var down = Input.is_action_pressed('ui_down')

	# Map horizontal movement
	input.x = 0
	if right:
		input.x += 1
	elif left:
		input.x -= 1

	if left or right:
		# Input is already normalized, since x is either 1, 0 or -1 and y is 0
		velocity.x += input.x * acceleration * delta
		if velocity.x > speedLimit:
			velocity.x = speedLimit
		elif velocity.x < -speedLimit:
			velocity.x = -speedLimit
	else:
		var before = velocity.x
		velocity.x -= velocity.normalized().x * delta * (500 if down else acceleration)
		var after = velocity.x
		if before * after < 0:
			velocity.x = 0

	# Map vertical movement
	if grounded:
		if up:
			velocity.y -= jumpPower
		else:
			velocity.y = 1
	else:
		velocity.y += gravity * delta
		if velocity.y > fallingSpeedLimit:
			velocity.y = fallingSpeedLimit

	# Movement and Collision

	# Automatic handling of collisions
	# var _movement = move_and_slide(velocity, Vector2(0, -1), true, 2, 0.8, true)
	# if get_slide_count() > 0 and is_on_floor():
	# 	grounded = true
	# else:
	# 	grounded = false

	# Manual handling of collisions
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collision_normal = collision.get_normal()

		if collision_normal.y < -0.7:
			grounded = true
			velocity = velocity.slide(collision_normal)
		else:
			grounded = false
			velocity = velocity.bounce(collision_normal)
	else:
		grounded = false

	$Camera2D/DebugLabel.text = 'speed x: ' + str(round(velocity.x)) + '\n' + \
								'speed y: ' + str(round(velocity.y)) + '\n' +\
								'grounded: ' + str(grounded) + '\n' + \
								'collision: ' + (str(collision.get_normal()) if collision else 'none')

func _process(_delta):
	if Input.is_action_pressed('ui_reset'):
		var _tmp = get_tree().reload_current_scene()

	var left = Input.is_action_pressed('ui_left')
	var right = Input.is_action_pressed('ui_right')
	var down = Input.is_action_pressed('ui_down')

	if left:
		$AnimatedSprite.flip_h = true
	elif right:
		$AnimatedSprite.flip_h = false

	$AnimatedSprite.offset.y = 0

	if not grounded:
		$AnimatedSprite.play("Jump")
	elif right || left:
		$AnimatedSprite.play("Walk")
	elif down:
		$AnimatedSprite.play("Duck")
		$AnimatedSprite.offset.y = 22
	else:
		$AnimatedSprite.play("Idle")
