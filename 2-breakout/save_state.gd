extends Node


var _save_file_path = "user://breakout_save_game.json"
var _state = {}

func set_value(key, value):
	_state[key] = value

func get_value(key, default = null):
	return _state.get(key, default)

func save():
	var file = FileAccess.open(_save_file_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(_state))

func load():
	if not FileAccess.file_exists(_save_file_path):
		return

	var file = FileAccess.open(_save_file_path, FileAccess.READ)
	var content = file.get_as_text()
	_state = JSON.parse_string(content)
	
	EventManager.state_loaded.emit(_state)
