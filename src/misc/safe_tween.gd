class_name SafeTween


var _tween: Tween


func kill() -> void:
	if is_instance_valid(_tween) and _tween.is_valid():
		_tween.kill()
	_tween = null


func create_from(node: Node) -> Tween:
	_tween = node.create_tween()
	return _tween
