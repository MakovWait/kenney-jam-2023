extends Area2D

signal killed

@export var _random_speed: RandomSpeed
@export var _random_texture: RandomTexture2D

@onready var _gfx := $GroundedGfx

var _target: Vector2
var _speed = 0.0


func _ready() -> void:
	_random_texture.set_to(_gfx)
	_speed = _random_speed.get_value()


func take_hit():
	killed.emit()


func init_creep(spawn_position: Vector2, target_position: Vector2):
	position = spawn_position
	_target = target_position


func _process(delta: float) -> void:
	position += position.direction_to(_target) * _speed * delta


func _on_area_entered(area: Area2D) -> void:
	area.take_hit()
