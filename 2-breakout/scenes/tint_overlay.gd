extends ColorRect


func _ready():
	EventManager.lose_life.connect(_lose_life)
	EventManager.game_over.connect(_game_over)
	EventManager.serve.connect(_serve)
	EventManager.level_start.connect(_level_start)

func _tint_on():
	color.a = 0.5

func _tint_off():
	color.a = 0.0

func _lose_life():
	_tint_on()
	
func _game_over():
	_tint_on()

func _serve():
	_tint_off()

func _level_start(level_nr):
	_tint_on()
