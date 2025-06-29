extends Node2D

var max_time = 1.0
var time_left = 0.0
var can_change = false

enum {CHAR_1, CHAR_2}
var state

# Called when the node enters the scene tree for the first time.
func _ready():
	time_left = max_time
	state = CHAR_1

func _process(delta):
	if time_left > 0.0:
		time_left -= delta
		print(time_left)
	elif time_left <= 0.0 and can_change == false:
		print("Can now change characters")
		can_change = true
	
	match state:
		CHAR_1:
			if Input.is_action_just_pressed("switch") and can_change == true:
				state = CHAR_1
				print(state)
				print("char 1 active")
				reset_char_switch_delay()
		CHAR_2:
			if Input.is_action_just_pressed("switch") and can_change == true:
				state = CHAR_2
				print(state)
				print("char 2 active")
				reset_char_switch_delay()

func reset_char_switch_delay():
	time_left = max_time
	can_change = false
