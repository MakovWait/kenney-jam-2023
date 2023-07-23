extends "res://src/hand/hand.gd"


func _process(delta: float) -> void:
	super._process(delta)
	global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("slam"):
		slam()
