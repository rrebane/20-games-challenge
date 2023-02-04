extends Node2D

@export var num_players: int = 1

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		EventManager.reset.emit()
