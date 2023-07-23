extends Area2D

signal killed

@export var _random_speed: RandomSpeed
@export var _random_texture: RandomTexture2D

@export var _wander_radius = 100

@onready var _gfx := $GroundedGfx

var _target: Vector2
var _speed = 0.0
var _spawn_position: Vector2


func _ready() -> void:
	_random_texture.set_to(_gfx)
	_speed = _random_speed.get_value()
	
	var tween = create_tween()
	tween.tween_callback(func find_target():
		_target = _spawn_position + Vector2.UP.rotated(
			deg_to_rad(randf_range(0, 360))
		) * _wander_radius
	)
	tween.tween_interval(randf_range(1, 3))
	tween.tween_callback(func reset_target():
		_target = position
	)
	tween.tween_interval(randf_range(0.5, 2))
	tween.set_loops()


func take_hit():
	killed.emit()


func set_spawn_position(value: Vector2):
	_spawn_position = value
	position = value


func _process(delta: float) -> void:
	position += position.direction_to(_target) * _speed * delta
