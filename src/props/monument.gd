extends Sprite2D


@export var _random_texture: RandomTexture2D


func _ready() -> void:
	_random_texture.set_to(self)
