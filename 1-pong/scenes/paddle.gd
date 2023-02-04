extends Node2D

@export var player_nr: int = 1
@export var paddle_height: float = 100
@export var paddle_width: float = 25

var _speed: float = 600

var _ball
var _enabled = true
var _mode = MODE_PLAYER
var _up_action1
var _down_action1
var _up_action2
var _down_action2
var _start_position

enum {MODE_PLAYER, MODE_CPU}

func _ready():
	EventManager.game_over.connect(_game_over)
	EventManager.reset.connect(_reset)

	_ball = get_tree().get_nodes_in_group("ball")[0]

	_up_action1 = "player{0}_up".format([player_nr])
	_down_action1 = "player{0}_down".format([player_nr])
	
	_start_position = position

func _process(delta):
	if not _enabled:
		return

	if get_parent().num_players == 1:
		if player_nr == 1:
			_up_action2 = "player2_up"
			_down_action2 = "player2_down"
		else:
			_mode = MODE_CPU
	else:
		if player_nr == 1:
			_up_action2 = null
			_down_action2 = null
		else:
			_mode = MODE_PLAYER

	if _mode == MODE_PLAYER:
		_process_player(delta)
	else:
		_process_cpu(delta)

func _process_player(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed(_up_action1) or (_up_action2 and Input.is_action_pressed(_up_action2)):
		direction += Vector2.UP
	
	if Input.is_action_pressed(_down_action1) or (_down_action2 and Input.is_action_pressed(_down_action2)):
		direction += Vector2.DOWN

	var new_position = position + direction * _speed * delta
	
	if new_position.y < paddle_height / 2:
		position.y = paddle_height / 2
	elif new_position.y > Constants.SCREEN_HEIGHT - paddle_height / 2:
		position.y = Constants.SCREEN_HEIGHT - paddle_height / 2
	else:
		position = new_position
	
func _process_cpu(delta):
	var direction = Vector2.ZERO

	if _ball.position.y < position.y - paddle_height / 2:
		direction += Vector2.UP
	elif _ball.position.y > position.y + paddle_height / 2:
		direction += Vector2.DOWN

	var new_position = position + direction * _speed * delta
	
	if new_position.y < paddle_height / 2:
		position.y = paddle_height / 2
	elif new_position.y > Constants.SCREEN_HEIGHT - paddle_height / 2:
		position.y = Constants.SCREEN_HEIGHT - paddle_height / 2
	else:
		position = new_position

func _game_over(_player):
	_enabled = false

func _reset():
	position = _start_position
	_enabled = true
