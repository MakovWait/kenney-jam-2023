extends Node

const creep_scene = preload("res://src/creep/creep.tscn")
const splat_scene = preload("res://src/props/splat.tscn")

signal creep_killed

@onready var _grounded_entities_container := %GroundedEntities
@onready var _ground: Node2D = $"../Ground"

@export var _max_creeps = 500

var _free_creeps = []
var _spawn_timer
var _creep_spawn_rate_number = 1
var _creep_spawn_rate_wait = 1.5

var _time


func _ready() -> void:
	_free_creeps.resize(_max_creeps)
	for _i in range(_max_creeps):
		var creep = creep_scene.instantiate()
		_free_creeps.append(creep)
		creep.killed.connect(func():
			var splat = splat_scene.instantiate()
			_ground.add_child(splat)
			splat.global_position = creep.global_position
			
			_grounded_entities_container.remove_child(creep)
			_free_creeps.append(creep)
			creep_killed.emit()
		)
	
	_spawn_timer = Timer.new()
	add_child(_spawn_timer)
	_spawn_timer.start(_creep_spawn_rate_wait)
	_spawn_timer.timeout.connect(func():
		for _i in _creep_spawn_rate_number:
			var creep = _free_creeps.pop_back()
			if not is_instance_valid(creep):
				continue
			var spawn_pos = Vector2.UP.rotated(
				deg_to_rad(randf_range(0, 360))
			) * 500
			var target_pos = Vector2.ZERO
			_grounded_entities_container.add_child(creep)
			creep.init_creep(spawn_pos, target_pos)
	)
	
	_create_difficulte_increase_timer(0.1, 1, 10)
	_create_difficulte_increase_timer(60, 0.5, 10)
	_create_difficulte_increase_timer(120, 0.25, 10)
	_create_difficulte_increase_timer(180, 0.1, 10)


func _create_difficulte_increase_timer(wait_time, spawn_delay, spawn_number):
	var timer = Timer.new()
	add_child(timer)
	timer.start(wait_time)
	timer.one_shot = true
	timer.timeout.connect(func():
		_creep_spawn_rate_number = spawn_number
		_creep_spawn_rate_wait = spawn_delay
	)


func _exit_tree():
	for creep in _free_creeps:
		if is_instance_valid(creep):
			creep.free()
