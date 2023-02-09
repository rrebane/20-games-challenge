extends Label


var _score: int = 0
var _high_score: int = 0

func _ready():
	EventManager.score.connect(_increase_score)
	EventManager.reset.connect(_reset)
	EventManager.state_loaded.connect(_state_loaded)

func _increase_score(points):
	_score += points
	
	if _high_score < _score:
		_high_score = _score
		SaveState.set_value("high_score", _high_score)
		text = str(_high_score)

func _reset():
	_score = 0

func _state_loaded(_state):
	_high_score = SaveState.get_value("high_score", 0)
	text = str(_high_score)
