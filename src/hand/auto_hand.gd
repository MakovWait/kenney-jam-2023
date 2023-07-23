extends "res://src/hand/hand.gd"

@export var _speed = 100

var _target = Vector2.ZERO

func _ready() -> void:
	var tween = create_tween()
	tween.tween_callback(func find_target():
		_target = Vector2.UP.rotated(
			deg_to_rad(randf_range(0, 360))
		) * 350
	)
	tween.tween_interval(2)
	tween.set_loops()
	
	var slam_tween = create_tween()
	slam_tween.tween_callback(func(): slam())
	slam_tween.tween_interval(0.2)
	slam_tween.set_loops()


func _process(delta: float) -> void:
	super._process(delta)
	position += position.direction_to(_target) * _speed * delta
