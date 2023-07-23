extends Node2D


func _ready() -> void:
	await get_tree().create_timer(randf_range(0, 2)).timeout
	var tween = create_tween()
	tween.tween_property(self, "skew", deg_to_rad(5), 2)
	tween.tween_property(self, "skew", deg_to_rad(-5), 2)
	tween.set_loops()
