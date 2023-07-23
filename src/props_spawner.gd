extends Node

@export var _house_propses: Array[PackedScene] = []
@export var _rest_propses: Array[PackedScene] = []
@export var _max_spawn_radius = 400
@export var _min_spawn_radius = 0

@onready var _random_props: Node2D = $"../RandomProps"
@onready var _grounded_entities: Node2D = %GroundedEntities

var _current_spawn_radius_squared = 0.0
var _current_spawn_radius = 0.0


func _ready() -> void:
	$HouseSpawnTimer.start(20)
	$HouseSpawnTimer.timeout.connect(func():
		_spawn(_house_propses.pick_random(), _random_props.get_node("Houses"))
	)
	
	$RestSpawnTimer.start(10)
	$RestSpawnTimer.timeout.connect(func():
		if len(_rest_propses) > 0:
			var prop = _rest_propses.pick_random().instantiate()
			_grounded_entities.add_child(prop)
			prop.position = Vector2.UP.rotated(
				deg_to_rad(randf_range(0, 360))
			) * randf_range(0, _current_spawn_radius)
	)


func _on_inhabitants_current_inhabitants_number_changed(value) -> void:
	_current_spawn_radius = lerp(_min_spawn_radius, _max_spawn_radius, value / 50)
	_current_spawn_radius_squared = _current_spawn_radius * _current_spawn_radius


func _spawn(scene: PackedScene, markers):
	if not is_instance_valid(scene):
		return

	var possible_points = []
	for child in markers.get_children():
		if child.has_meta("used"):
			continue
		if child.position.length_squared() <= _current_spawn_radius_squared:
			possible_points.append(child)
	
	if len(possible_points) > 0:
		var point = possible_points.pick_random()
		var prop = scene.instantiate()
		_grounded_entities.add_child(prop)
		prop.position = point.position
		point.set_meta("used", true)
