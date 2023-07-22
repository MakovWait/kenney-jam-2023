extends Node2D


@onready var _shadow: Sprite2D = $Shadow
@onready var _body: Sprite2D = $Body


func set_texture(texture):
	_shadow.texture = texture
	_body.texture = texture
