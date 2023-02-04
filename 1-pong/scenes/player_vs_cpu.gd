extends Button


func _pressed():
	SceneManager.goto_scene("res://scenes/main.tscn", {"num_players": 1})
