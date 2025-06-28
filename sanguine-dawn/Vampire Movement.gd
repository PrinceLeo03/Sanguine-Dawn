extends CharacterBody2D

@export var walk_speed = 200.0
@export var run_speed = 300.0
@export var jump_force = -600.0
@export var fall_multipiler := 0.2

@export_range(0, 1) var acceleration = 0.2
@export_range(0, 1) var deceleration = 0.2
@export_range(0, 1) var deceleration_on_jump_release = 0.4

@export var coyote_time_duration := 0.15
var coyote_time_left := 0.0

@export var jump_buffer_time := 0.15
var jump_buffer_left := 0.0

@export var dash_speed = 1000.0
@export var dash_max_distance = 300.0
@export var dash_curve : Curve
@export var dash_cooldown = 1.0

# Gets gravity from 
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_dashing = false
var dash_start_position = 0
var dash_direction = 0
var dash_timer = 0.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

# Update Coyote timer
	if is_on_floor():
		coyote_time_left = coyote_time_duration
	else:
		coyote_time_left -= delta

	# Register jump input for buffer
	if Input.is_action_just_pressed("jump"):
		jump_buffer_left = jump_buffer_time
	# Reduce jump buffer time
	else:
		jump_buffer_left -= delta

# Coyote Time or Wall Jump
	if jump_buffer_left > 0 and (is_on_floor() or coyote_time_left > 0 or is_on_wall()):
			#regular jump
			velocity.y = jump_force
			print("Ground jump")
			jump_buffer_left = 0.0  #Clears Buffer

# Varible Jump Height
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= deceleration_on_jump_release

	# Faster falling logic
	if velocity.y > 0:
		velocity += get_gravity() * fall_multipiler * delta
	else:
		velocity += get_gravity() * delta

# Controls running/sprinting
	var speed
	if Input.is_action_pressed("run"):
		speed = run_speed
	else:
		speed = walk_speed

	# Get the input direction and handle the movement/deceleration and acceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)

	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false

	#Dash Activation
	if Input.is_action_just_pressed("dash") and direction and not is_dashing and dash_timer <= 0.0:
		is_dashing = true
		dash_start_position = position.x
		dash_direction = direction
		dash_timer = dash_cooldown
		print("Dash")

	# Performs dash
	if is_dashing:
		var current_distance = abs(position.x - dash_start_position)
		if current_distance >= dash_max_distance:
			is_dashing = false
		elif velocity.x == 0:
			is_dashing = false
		else:
			velocity.x = dash_direction * dash_speed * dash_curve.sample(current_distance / dash_max_distance)
			velocity.y = 0

	#reduces dash timer
	if dash_timer > 0.0:
		dash_timer -= delta

	move_and_slide()
