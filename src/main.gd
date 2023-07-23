extends Node2D

@onready var _shop: Node = $Shop


func _ready() -> void:
#	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED_HIDDEN)
	pass


func _on_inhabitants_last_inhabitant_killed() -> void:
	pass


func _on_creeps_creep_killed() -> void:
	_shop.wallet.receive(1)
