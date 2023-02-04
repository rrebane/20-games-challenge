extends Label

var _enabled: bool = true

func _ready():
	EventManager.serve.connect(_serve)
	EventManager.player_score.connect(_player_score)
	EventManager.game_over.connect(_game_over)
	EventManager.reset.connect(_reset)

func _serve():
	text = ""

func _player_score(player_nr):
	if not _enabled:
		return
	text = "Player {0} scores".format([player_nr])
	
func _game_over(player_nr):
	_enabled = false
	text = "Player {0} wins\nPress 'R' to restart".format([player_nr])

func _reset():
	_enabled = true
