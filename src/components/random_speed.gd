class_name RandomSpeed
extends Resource

@export var _min_speed = 10.
@export var _max_speed = 30.


func get_value() -> float:
	return randf_range(_min_speed, _max_speed)
