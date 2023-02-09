extends ColorRect


func _ready():
	EventManager.lose_life.connect(_lose_life)
	EventManager.serve.connect(_serve)

func _lose_life():
	color.a = 0.5

func _serve():
	color.a = 0.0
