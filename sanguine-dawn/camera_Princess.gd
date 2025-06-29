extends Camera2D
class_name CustomCamera2D_1

@export var TargetNode : Node2D = null
@export var TargetNode2 : Node2D = null

func _process(delta) -> void:
	set_position(TargetNode.get_position())

func asdf() -> void:
	if $CHAR_1.visible == true:
		set_position(TargetNode.get_position())
	else:
		set_position(TargetNode2.get_position())
