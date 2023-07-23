extends Area2D

@export var _idle_pos := Vector2(5.0, -10.0)
@export var _idle_skew := -18

@onready var _body_sprite = $Sprite2D
@onready var _shadow_sprite = $Shadow

var _tween := SafeTween.new()


func _ready() -> void:
	_body_sprite.position = _idle_pos
	scale *= 2
	_set_gfx_skew(_idle_skew)


func slam():
#	_body_sprite.position = Vector2(0, 0)
#	_set_gfx_skew(-30)
	var tween = _tween.create_from(self)
	
	tween.tween_property(_body_sprite, "position", Vector2(0, 0), 0.02)
	
	tween.tween_callback(_smash)
	
	tween.tween_property(
		_body_sprite, "position", _idle_pos, 1
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	tween.parallel().tween_method(_set_gfx_skew, -9, _idle_skew, 0.2)


func _smash():
	for area in get_overlapping_areas():
		area.take_hit()


func _set_gfx_skew(value):
	var rad = deg_to_rad(value)
	_shadow_sprite.skew = rad
	_body_sprite.skew = rad


func _process(delta: float) -> void:
	_shadow_sprite.scale = Vector2.ONE * lerp(1.0, 0.7, _body_sprite.position.length() / _idle_pos.length())
