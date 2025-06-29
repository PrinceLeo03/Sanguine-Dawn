extends Node

@export var dash_speed = 1000.0
@export var dash_max_distance = 300.0
@export var dash_curve : Curve
@export var dash_cooldown = 1.0

var is_dashing = false
var dash_start_position = 0
var dash_direction = 0
var dash_timer = 0

	#Dash Activation
if Input.is_action_just_pressed("dash") and direction and not is_dashing and dash_timer <= 0
	is_dashing = true
	dash_start_position = position.x
	dash_direction = direction
	dash_timer = dash_cooldown

	# Performs dash
var current_distance = abs(position.x - dash_start_position)
if current_distance >= dash_max_distance:
	is_dashing = false
else:
	velocity.x = dash_direction * dash_speed * dash_curve.sample(current_distance / dash_max_distance)
	velocity.y = 0

	#reduces dash timer
	if dash_timer > 0:
		dash_timer -= delta
