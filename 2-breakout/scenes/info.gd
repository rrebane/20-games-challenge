extends Label

var _enabled: bool = true

func _ready():
	EventManager.serve.connect(_serve)
	EventManager.lose_life.connect(_lose_life)
	EventManager.game_over.connect(_game_over)
	EventManager.reset.connect(_reset)

func _serve():
	text = ""

func _lose_life(player_nr):
	if not _enabled:
		return
	
func _game_over():
	_enabled = false
	text = "Game Over\nPress 'R' to restart"

func _reset():
	_enabled = true
