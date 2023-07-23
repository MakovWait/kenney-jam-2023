extends Node2D


@onready var _shadow: Sprite2D = $Shadow
@onready var _body: Sprite2D = $Body


func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "skew", deg_to_rad(5), 1)
	tween.tween_property(self, "skew", deg_to_rad(-5), 1)
	tween.set_loops()


func set_texture(texture):
	_shadow.texture = texture
	_body.texture = texture
