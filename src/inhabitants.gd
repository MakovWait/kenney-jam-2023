extends Node

signal current_inhabitants_number_changed(value)
signal last_inhabitant_killed

const inhabitant_scene = preload("res://src/inhabitant/inhabitant.tscn")
const monument_scene = preload("res://src/props/monument.tscn")

@export var _max_inhabitants = 300
@export var _inhabitants_to_initial_spawn = 150
@export var _spawn_rate = 1.

@onready var _grounded_entities_container := %GroundedEntities

var _free_inhabitants = []
var _spawn_timer: Timer
var _current_inhabitants_number = 0:
	set(value): 
		%InhabitantLabel.text = str(value)
		_current_inhabitants_number = value
		current_inhabitants_number_changed.emit(value)


func _ready() -> void:
	_free_inhabitants.resize(_max_inhabitants)
	for _i in range(_max_inhabitants):
		var inhabitant = inhabitant_scene.instantiate()
		_free_inhabitants.append(inhabitant)
		inhabitant.killed.connect(func():
			var monument = monument_scene.instantiate()
			_grounded_entities_container.add_child(monument)
			monument.global_position = inhabitant.global_position
			
			_current_inhabitants_number -= 1
			_grounded_entities_container.remove_child(inhabitant)
			_free_inhabitants.append(inhabitant)
			
			if _current_inhabitants_number == 0:
				monument.process_mode = Node.PROCESS_MODE_ALWAYS
				monument.z_index = 10
				get_tree().paused = true
				var tween = create_tween()
				
#				print(monument.global_position)
				tween.tween_property(%Camera2D, "global_position", monument.global_position, 0.1)
				tween.tween_interval(1)
				tween.tween_property(%Camera2D, "zoom", Vector2(3, 3), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
				tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
				tween.tween_property(%RestartLabel, "scale", Vector2(1, 1), 1).from(Vector2.ZERO).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
				tween.parallel().tween_callback(func():
					%RestartLabel.visible = true
				)
				
				%GameOverColorRect.visible = true
				%PanelContainer.visible = false
		)
	
	_spawn_timer = Timer.new()
	add_child(_spawn_timer)
	_spawn_timer.start(_spawn_rate)
	_spawn_timer.timeout.connect(func():
		spawn_inhabitant()
	)
	
	for _i in range(_inhabitants_to_initial_spawn):
		spawn_inhabitant()
	
	current_inhabitants_number_changed.connect(func(value): 
		if value == 0:
			_spawn_timer.stop()
			last_inhabitant_killed.emit()
	)


func spawn_inhabitant():
	var inhabitant = _free_inhabitants.pop_back()
	if not is_instance_valid(inhabitant):
		return
	_current_inhabitants_number += 1
	_grounded_entities_container.add_child(inhabitant)
	inhabitant.set_spawn_position(Vector2(0, 0))


func _exit_tree() -> void:
	for inhabitant in _free_inhabitants:
		if is_instance_valid(inhabitant):
			inhabitant.free()
