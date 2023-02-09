extends Label

@export var start_lives: int = 3

var _lives: int = 0

func _ready():
	EventManager.lose_life.connect(_lose_life)
	EventManager.reset.connect(_reset)
	
	_lives = start_lives
	text = str(_lives)

func _lose_life():
	_lives -= 1
	text = str(_lives)

	if _lives <= 0:
		EventManager.game_over.emit()

func _reset():
	_lives = start_lives
	text = str(_lives)
