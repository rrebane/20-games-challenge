extends Node2D

var _wide_paddle_size: Vector2 = Vector2.ZERO
var _narrow_paddle_size: Vector2 = Vector2.ZERO

var _speed: float = 800.

var _enabled = true
var _start_position = Vector2.ZERO
var _narrow = false

func _ready():
	_wide_paddle_size = $WideSprite2D.get_rect().size
	_narrow_paddle_size = $NarrowSprite2D.get_rect().size
	
	EventManager.game_over.connect(_game_over)
	EventManager.reset.connect(_reset)
	EventManager.serve.connect(_serve)
	EventManager.ceiling_touched.connect(_ceiling_touched)
	
	_start_position = position

func _process(delta):
	if not _enabled:
		return

	var direction = Vector2.ZERO

	if Input.is_action_pressed("player_left"):
		direction += Vector2.LEFT
	
	if Input.is_action_pressed("player_right"):
		direction += Vector2.RIGHT

	var new_position = position + direction * _speed * delta
	
	var paddle_width = paddle_width()
	
	if new_position.x < paddle_width / 2:
		position.x = paddle_width / 2
	elif new_position.x > Constants.SCREEN_WIDTH - paddle_width / 2:
		position.x = Constants.SCREEN_WIDTH - paddle_width / 2
	else:
		position = new_position

func _game_over():
	_enabled = false

func _reset():
	position = _start_position
	_enabled = true
	$WideSprite2D.visible = true
	$NarrowSprite2D.visible = false
	_narrow = false

func _serve():
	if _enabled and _narrow:
		$WideSprite2D.visible = true
		$NarrowSprite2D.visible = false
		_narrow = false

func _ceiling_touched():
	if _enabled and not _narrow:
		$WideSprite2D.visible = false
		$NarrowSprite2D.visible = true
		_narrow = true

func paddle_width():
	if _narrow:
		return _narrow_paddle_size.x
	else:
		return _wide_paddle_size.x

func paddle_height():
	if _narrow:
		return _narrow_paddle_size.y
	else:
		return _wide_paddle_size.y
