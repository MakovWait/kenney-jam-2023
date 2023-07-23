class_name SafeTween


var _tween: Tween


func kill() -> void:
	if is_instance_valid(_tween) and _tween.is_running():
		_tween.stop()
		_tween.kill()
	_tween = null


func create_from(node: Node) -> Tween:
	kill()
	_tween = node.create_tween()
	return _tween
