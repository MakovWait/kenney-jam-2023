extends Node

const soldier_scene = preload("res://src/inhabitant/soldier.tscn")
const hand_scene = preload("res://src/hand/auto_hand.tscn")

var wallet = Wallet.new(0)

@onready var _grounded_entities: Node2D = %GroundedEntities
@onready var _camera: Camera2D = %Camera2D
@onready var _shop_buttons_container: VBoxContainer = %ShopButtonsContainer

var _visible_rect


func _ready() -> void:
	_cache_visible_rect()
	
	var items = [
		Item.new(
			1,
			3,
			preload("res://assets/kenney_tiny-dungeon/Tiles/tile_0096.png"),
			func(): spawn_soldier()
		),
		Item.new(
			100,
			10,
			preload("res://assets/kenney_input-prompts-pixel-16/Tiles/tile_0581.png"),
			func(): spawn_hand()
		),
		Item.new(
			2000,
			10,
			preload("res://assets/kenney_tiny-dungeon/Tiles/tile_0089.png"),
			func(): victory()
		),
	]
	
	for item in items:
		var button = _bind_button_to(item)
		_shop_buttons_container.add_child(button)
	
	var update_label = func():
		%GoldLabel.text = str(wallet.value)
	wallet.value_changed.connect(update_label)
	update_label.call()
	

func _bind_button_to(item: Item):
	var button = Button.new()
	button.icon = item.icon
	button.pressed.connect(func():
		item.buy(wallet)
	)
	var update = func():
		button.text = str(item.price)
		button.disabled = not item.is_affordable(wallet.value)
	item.price_changed.connect(update)
	wallet.value_changed.connect(update)
	update.call()
	return button


func spawn_soldier():
	var soldier = soldier_scene.instantiate()
	_grounded_entities.add_child(soldier)
#	soldier.set_spawn_position(_random_visible_point())
	soldier.set_spawn_position(Vector2.ZERO)


func spawn_hand():
	var hand = hand_scene.instantiate()
	_grounded_entities.add_child(hand)
	hand.position = _random_visible_point()
#	soldier.set_spawn_position(_random_visible_point())


func _random_visible_point() -> Vector2:
	var visible_rect = _visible_rect
	return Vector2(
		randf_range(0, visible_rect.size.x),
		randf_range(0, visible_rect.size.y),
	) + visible_rect.position


func victory():
	get_tree().paused = true
	var tween = create_tween()
	
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(%VictoryLabel, "scale", Vector2(1, 1), 1).from(Vector2.ZERO).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_callback(func():
		%VictoryLabel.visible = true
	)
	tween.tween_property(%RestartLabel, "scale", Vector2(1, 1), 1).from(Vector2.ZERO).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_callback(func():
		%RestartLabel.visible = true
	)
	
	%GameOverColorRect.visible = true
	%PanelContainer.visible = false


func _cache_visible_rect():
	var viewport: Viewport = _camera.get_viewport()
	var viewport_rect: Rect2 = _camera.get_viewport_rect()
	var global_to_viewport: Transform2D = viewport.global_canvas_transform * _camera.get_canvas_transform()
	var viewport_to_global: Transform2D = global_to_viewport.affine_inverse()
	var viewport_rect_global: Rect2 = viewport_to_global * viewport_rect	
	_visible_rect = viewport_rect_global


class Item:
	signal price_changed
	
	var icon:
		get: return _icon
	var price:
		get: return _price
	
	var _icon
	var _price_derivative
	var _buy_callback: Callable
	var _price:
		set(value):
			_price = value
			price_changed.emit()
	
	func _init(
		start_price: int, 
		price_derivative: int, 
		icon: Texture2D,
		buy_callback: Callable,
	) -> void:
		_price = start_price
		_price_derivative = price_derivative
		_icon = icon
		_buy_callback = buy_callback
	
	func buy(wallet):
		wallet.spend(_price)
		_price += _price_derivative
		_buy_callback.call()
	
	func is_affordable(money):
		return money >= _price


class Wallet:
	signal value_changed()
	
	var value:
		get: return _value
	
	var _value:
		set(value):
			_value = value
			value_changed.emit() 
	
	func _init(amount) -> void:
		_value = amount
	
	func receive(amount):
		_value += amount
	
	func spend(amount):
		_value -= amount
