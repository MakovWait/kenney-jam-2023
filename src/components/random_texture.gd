class_name RandomTexture2D
extends Resource


@export var _textures: Array[Texture2D] = []


func set_to(texture_holder) -> void:
	if len(_textures) > 0:
		texture_holder.set_texture(_textures.pick_random())
