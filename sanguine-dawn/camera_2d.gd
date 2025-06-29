extends Camera2D

func _process(delta):
	if $"/root/Node2D/Player/CHAR_1".visible == true:
		$"/root/Node2D/Player/CHAR_1/Cam 1".make_current()
	elif $"/root/Node2D/Player/CHAR_2".visible == true:
		$"/root/Node2D/Player/CHAR_2/Cam 2".make_current()
