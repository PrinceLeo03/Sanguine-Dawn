extends CharacterBody2D


@export var walk_speed = 150.0
@export var run_speed = 250.0
@export var jump_force = -400.0

@export_range(0, 1) var acceleration = 0.1
@export_range(0, 1) var deceleration = 0.1
@export_range(0, 1) var deceleration_on_jump_release = 0.5

# Gets gravity from 
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

# Varible Jump Height
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= deceleration_on_jump_release

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
