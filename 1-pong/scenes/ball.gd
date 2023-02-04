extends Node2D

@export var speed_multiplier: float = 1.1

var _start_position: Vector2 = Vector2(Constants.SCREEN_WIDTH / 2., Constants.SCREEN_HEIGHT / 2.)
var _start_speed: float = 400
var _serve_timeout: float = 1.5
var _serve_hit_timeout: float = 0.5
var _ball_radius: float = 12.5
var _max_bounce_angle = PI / 4.

var _player1
var _player2
var _enabled: bool = true
var _wait_for_serve: bool = true
var _start_x_direction = 1
var _velocity: Vector2 = Vector2.ZERO
var _current_speed_multiplier: float = 1.

func _ready():
	EventManager.game_over.connect(_game_over)
	EventManager.reset.connect(_reset)
	$Timer.timeout.connect(_serve)
	$Timer2.timeout.connect(_serve_hit)

	_player1 = get_tree().get_nodes_in_group("player1")[0]
	_player2 = get_tree().get_nodes_in_group("player2")[0]

	_start_x_direction = -1 if randf() < 0.5 else 1
	_serve(_start_position)

func _process(delta):
	if not _enabled:
		return

	if _wait_for_serve:
		return

	var new_position = position + _velocity * _current_speed_multiplier * delta

	if new_position.y < _ball_radius:
		new_position.y = 2 * _ball_radius - new_position.y
		_velocity.y *= -1.
		$WallBounceAudio.play()
	elif new_position.y > Constants.SCREEN_HEIGHT - _ball_radius:
		new_position.y = 2 * (Constants.SCREEN_HEIGHT - _ball_radius) - new_position.y
		_velocity.y *= -1.
		$WallBounceAudio.play()
		
	var player1_x_threshold = _player1.position.x + _player1.paddle_width / 2. + _ball_radius
	var player2_x_threshold = _player2.position.x - _player2.paddle_width / 2. - _ball_radius
		
	if position.x >= player1_x_threshold and new_position.x < player1_x_threshold:
		var upper_threshold = _player1.position.y - _player1.paddle_height / 2. - _ball_radius
		var lower_threshold = _player1.position.y + _player1.paddle_height / 2. + _ball_radius

		if new_position.y >= upper_threshold and new_position.y <= lower_threshold:
			new_position.x = 2 * player1_x_threshold - new_position.x
			_current_speed_multiplier *= speed_multiplier
			var bounce_angle = (new_position.y - _player1.position.y) / (_player1.paddle_height / 2.)
			_velocity = Vector2(
				cos(bounce_angle * _max_bounce_angle),
				sin(bounce_angle * _max_bounce_angle)
			) * _start_speed
			$PaddleBounceAudio.play()
	elif position.x <= player2_x_threshold and new_position.x > player2_x_threshold:
		var upper_threshold = _player2.position.y - _player2.paddle_height / 2. - _ball_radius
		var lower_threshold = _player2.position.y + _player2.paddle_height / 2. + _ball_radius

		if new_position.y >= upper_threshold and new_position.y <= lower_threshold:
			new_position.x = 2 * player2_x_threshold - new_position.x
			_current_speed_multiplier *= speed_multiplier
			var bounce_angle = (new_position.y - _player2.position.y) / (_player2.paddle_height / 2.)
			_velocity = Vector2(
				-cos(bounce_angle * _max_bounce_angle),
				sin(bounce_angle * _max_bounce_angle)
			) * _start_speed
			$PaddleBounceAudio.play()
	else:
		if new_position.x < _ball_radius or new_position.x > Constants.SCREEN_WIDTH - _ball_radius:
			_player_score(2 if new_position.x < _ball_radius else 1)
			$ScoreAudio.play()

	position = new_position

func _player_score(player_nr):
	_wait_for_serve = true
	$Sprite2D.visible = false
	_start_x_direction = 1 if player_nr == 1 else -1
	EventManager.player_score.emit(player_nr)
	$Timer.start(_serve_timeout)

func _choose_start_position():
	return Vector2(
		Constants.SCREEN_WIDTH / 2.,
		randf_range(_ball_radius, Constants.SCREEN_HEIGHT - _ball_radius)
	)

func _serve(start_position = _choose_start_position(), start_y_direction = randi_range(-1, 1)):
	if not _enabled:
		return

	EventManager.serve.emit()
	position = start_position
	_current_speed_multiplier = 1.
	_velocity = Vector2(_start_x_direction, start_y_direction) * _start_speed
	$Sprite2D.visible = true
	$Timer2.start(_serve_hit_timeout)
	
func _serve_hit():
	_wait_for_serve = false

func _game_over(_player_nr):
	_enabled = false

func _reset():
	$Timer.stop()
	$Timer2.stop()
	_enabled = true
	_wait_for_serve = true
	_start_x_direction = -1 if randf() < 0.5 else 1
	_serve(_start_position)
