extends StaticBody2D

var _score = 0

func set_score(score):
	_score = score

func set_color(color):
	$Sprite2D.modulate = color

func destroy():
	get_parent().remove_child(self)
	queue_free()
	EventManager.score.emit(_score)
