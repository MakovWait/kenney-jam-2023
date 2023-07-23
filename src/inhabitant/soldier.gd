extends "res://src/inhabitant/inhabitant.gd"


func _on_area_entered(area: Area2D) -> void:
	area.take_hit()
