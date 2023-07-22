extends Node


@onready var _grounded_entities_container := %GroundedEntities


func _ready() -> void:
	var timer2 = Timer.new()
	add_child(timer2)
	timer2.start(0.3)
	timer2.timeout.connect(func():
		var creep_scene = preload("res://src/creep/creep.tscn")
		var creep = creep_scene.instantiate()
		var spawn_pos = Vector2.UP.rotated(
			deg_to_rad(randf_range(0, 360))
		) * 350
		var target_pos = Vector2.ZERO
		_grounded_entities_container.add_child(creep)
		creep.init_creep(spawn_pos, target_pos)
		creep.smashed.connect(func():
			creep.queue_free()
		)
	)
