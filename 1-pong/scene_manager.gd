extends Node

var current_scene = null

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if current_scene.name == "Main":
			goto_scene("res://scenes/menu.tscn")
		else:
			get_tree().quit()

func goto_scene(path, extra_params={}):
	call_deferred("_deferred_goto_scene", path, extra_params)

func _deferred_goto_scene(path, extra_params):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
	for pname in extra_params:
		if current_scene.get(pname):
			current_scene.set(pname, extra_params[pname])
