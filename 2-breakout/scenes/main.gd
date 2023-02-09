extends Node2D

func _ready():
	SaveState.load()

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		SaveState.save()
		EventManager.reset.emit()
