extends Label

@export var player_nr: int = 1
@export var game_over_score: int = 10

var _score: int = 0

func _ready():
	EventManager.player_score.connect(_player_score)
	EventManager.reset.connect(_reset)

func _player_score(player):
	if player_nr == player:
		_score += 1
		text = str(_score)

	if _score >= game_over_score:
		EventManager.game_over.emit(player)

func _reset():
	_score = 0
	text = str(_score)
