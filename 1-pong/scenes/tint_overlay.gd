extends ColorRect


func _ready():
	EventManager.player_score.connect(_player_score)
	EventManager.serve.connect(_serve)

func _player_score(_player_nr):
	color.a = 0.5

func _serve():
	color.a = 0.0
