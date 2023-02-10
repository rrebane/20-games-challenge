extends RigidBody2D

@export var speed_multiplier: float = 1.02

var _start_position: Vector2 = Vector2(Constants.SCREEN_WIDTH / 2., Constants.SCREEN_HEIGHT / 2.)
var _start_speed: float = 500
var _serve_timeout: float = 1.5
var _serve_hit_timeout: float = 0.5
var _ball_radius: float = 0.
var _max_bounce_angle = PI / 4.

var _player
var _enabled: bool = true
var _wait_for_serve: bool = true
var _direction: Vector2 = Vector2.ZERO
var _current_speed_multiplier: float = 1.
var _start_speed_multiplier: float = 1.
var _max_speed_multiplier: float = 1.7

func _ready():
	_ball_radius = $Sprite2D.get_rect().size.x / 2.
	
	EventManager.game_over.connect(_game_over)
	EventManager.reset.connect(_reset)
	EventManager.level_start.connect(_level_start)
	$ServeTimer.timeout.connect(_serve)
	$ServeHitTimer.timeout.connect(_serve_hit)

	_player = get_tree().get_nodes_in_group("player")[0]

	_reset()

func _physics_process(delta):
	if not _enabled:
		return

	if _wait_for_serve:
		return

	var velocity = _direction * _start_speed * _current_speed_multiplier
	var new_position = position + velocity * delta

	if new_position.x < _ball_radius:
		new_position.x = 2 * _ball_radius - new_position.x
		if _direction.x < 0:
			_direction.x *= -1.
			$WallBounceAudio.play()
	elif new_position.x > Constants.SCREEN_WIDTH - _ball_radius:
		new_position.x = 2 * (Constants.SCREEN_WIDTH - _ball_radius) - new_position.x
		if _direction.x > 0:
			_direction.x *= -1.
			$WallBounceAudio.play()
	elif new_position.y < _ball_radius:
		new_position.y = 2 * _ball_radius - new_position.y
		if _direction.y < 0:
			_direction.y *= -1.
			EventManager.ceiling_touched.emit()
			$WallBounceAudio.play()
		
	var half_paddle_height = _player.paddle_height() / 2.
	var half_paddle_width = _player.paddle_width() / 2.

	var player_y_threshold = _player.position.y - half_paddle_height - _ball_radius
		
	if position.y <= player_y_threshold and new_position.y > player_y_threshold:
		var left_threshold = _player.position.x - half_paddle_width - _ball_radius
		var right_threshold = _player.position.x + half_paddle_width + _ball_radius

		if new_position.x >= left_threshold and new_position.x <= right_threshold:
			new_position.y = 2 * player_y_threshold - new_position.y
			var bounce_angle = (new_position.x - _player.position.x) / half_paddle_width
			_direction = Vector2(
				sin(bounce_angle * _max_bounce_angle),
				-cos(bounce_angle * _max_bounce_angle)
			).normalized()
			$PaddleBounceAudio.play()
	elif new_position.y > Constants.SCREEN_HEIGHT - _ball_radius:
			_lose_life()

	var collision = move_and_collide(velocity * delta)
	
	if collision:
		_direction = _direction.bounce(collision.get_normal())

		var collider = collision.get_collider()
		
		if collider.is_in_group("brick"):
			_current_speed_multiplier = clamp(
				_current_speed_multiplier * speed_multiplier,
				_start_speed_multiplier,
				_max_speed_multiplier
			)
			collider.destroy()
			$BrickDestroyedAudio.play()

func _lose_life():
	_serve_after(_serve_timeout)
	EventManager.lose_life.emit()
	$LoseLifeAudio.play()
	$ServeTimer.start(_serve_timeout)

	
func _serve_after(timeout):
	_wait_for_serve = true
	$Sprite2D.visible = false
	$ServeTimer.start(_serve_timeout)

func _choose_start_position():
	return _start_position

func _serve(start_position = _choose_start_position(), start_x_direction = -1 if randf() < 0.5 else 1):
	if not _enabled:
		return

	EventManager.serve.emit()
	position = start_position
	_current_speed_multiplier = _start_speed_multiplier
	_direction = Vector2(start_x_direction, 1).normalized()
	$Sprite2D.visible = true
	$ServeHitTimer.start(_serve_hit_timeout)
	
func _serve_hit():
	_wait_for_serve = false

func _game_over():
	_enabled = false

func _reset():
	$ServeTimer.stop()
	$ServeHitTimer.stop()
	_enabled = true
	_wait_for_serve = true

func _level_start(_level_nr):
	_reset()
	_serve_after(_serve_timeout)
