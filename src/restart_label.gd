extends Label



func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "rotation", deg_to_rad(-10), 1)
	tween.tween_property(self, "rotation", deg_to_rad(10), 1)
	tween.set_loops()
	
	pivot_offset = size / 2


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		get_tree().paused = false
