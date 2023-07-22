extends Node

const inhabitant_scene = preload("res://src/inhabitant/inhabitant.tscn")

@export var _max_inhabitants = 300
@export var _inhabitants_to_initial_spawn = 150

@onready var _grounded_entities_container := %GroundedEntities

var _free_inhabitants = []


func _ready() -> void:
	_free_inhabitants.resize(_max_inhabitants)
	for _i in range(_max_inhabitants):
		var inhabitant = inhabitant_scene.instantiate()
		_free_inhabitants.append(inhabitant)
		inhabitant.eaten.connect(func():
			_grounded_entities_container.remove_child(inhabitant)
			_free_inhabitants.append(inhabitant)
		)
		inhabitant.smashed.connect(func():
			_grounded_entities_container.remove_child(inhabitant)
			_free_inhabitants.append(inhabitant)
		)
	
	var timer = Timer.new()
	add_child(timer)
	timer.start(0.3)
	timer.timeout.connect(func():spawn_inhabitant())
	
	for _i in range(_inhabitants_to_initial_spawn):
		spawn_inhabitant()
	
#	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED_HIDDEN)


func spawn_inhabitant():
	var inhabitant = _free_inhabitants.pop_back()
	if not is_instance_valid(inhabitant):
		return
	var visible_rect = get_viewport().get_visible_rect()
	_grounded_entities_container.add_child(inhabitant)
#	inhabitant.set_spawn_position(Vector2(
#		randf_range(0, visible_rect.size.x),
#		randf_range(0, visible_rect.size.y),
#	))
	inhabitant.set_spawn_position(Vector2(0, 0))


func _exit_tree() -> void:
	for inhabitant in _free_inhabitants:
		if is_instance_valid(inhabitant):
			inhabitant.free()
