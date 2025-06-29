extends Camera2D
class_name CustomCamera2D_2

@export var TargetNode : Node2D = null

func _process(delta) -> void:
	set_position(TargetNode.get_position())

func asdf() -> void:
	if $CHAR_1.visible == false:
		set_position(TargetNode.get_position())
		print("Camera 1")
	else:
		pass
