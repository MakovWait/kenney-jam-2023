extends Node


@export var _target: Node
@export var _color: Color


func _ready() -> void:
	_create.call_deferred()


func _create():
	var parent = get_parent()
	var shadow = _target.duplicate()
	shadow.skew = deg_to_rad(-18)
	shadow.modulate = _color
	shadow.z_index = -1
	parent.add_child(shadow)
