extends CharacterBody2D

@export var walk_speed = 200.0
@export var run_speed = 300.0
@export var jump_force = -600.0
@export var jump_count = 0
@export var max_jumps = 2
@export var fall_multipiler := 0.2

@export_range(0, 1) var acceleration = 0.2
@export_range(0, 1) var deceleration = 0.2
@export_range(0, 1) var deceleration_on_jump_release = 0.4

@onready var coyote_timer = $"Coyote Timer"
@export var coyote_time_duration := 0.15
var coyote_time_left := 0.0

@export var jump_buffer_time := 0.15
var jump_buffer_left := 0.0

# Gets gravity from 
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

# Update Coyote timer
	if is_on_floor():
		coyote_time_left = coyote_time_duration
	else:
		coyote_time_left -= delta

	# Resets jump count, allows for double jump.
	if is_on_floor():
		jump_count = 0

	# Register jump input for buffer
	if Input.is_action_just_pressed("jump"):
		jump_buffer_left = jump_buffer_time
	# Reduce jump buffer time
	else:
		jump_buffer_left -= delta

# Jump Logic
	if jump_buffer_left > 0 and (is_on_floor() or coyote_time_left > 0 or jump_count < max_jumps):
		velocity.y = jump_force
		jump_count += 1
		print("jump")
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
	$Sprite2D.flip_h = velocity.x < 0

	move_and_slide()
