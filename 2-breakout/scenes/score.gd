extends Label

var _score: int = 0

func _ready():
	EventManager.score.connect(_increase_score)
	EventManager.reset.connect(_reset)

func _increase_score(points):
	_score += points
	text = str(_score)

func _reset():
	_score = 0
	text = str(_score)
