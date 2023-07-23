extends Node


@export var _target_scale = Vector2(1, 1)


func _ready() -> void:
	get_parent().scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(get_parent(), "scale", _target_scale, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
