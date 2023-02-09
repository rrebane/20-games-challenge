extends Node2D


var _brick_template = preload("res://scenes/brick.tscn")
var _brick_width = Constants.SCREEN_WIDTH / Constants.BRICK_COLS
var _brick_height = 24

var _row_color = [
	Color.RED,
	Color.RED,
	Color.ORANGE,
	Color.ORANGE,
	Color.GREEN,
	Color.GREEN,
	Color.YELLOW,
	Color.YELLOW
]

func _ready():
	EventManager.reset.connect(_reset)
	
	_reset()

func _reset():
	for child in get_children():
		if child.is_in_group("brick"):
			remove_child(child)
			child.queue_free()
	
	for y in range(Constants.BRICK_ROWS):
		for x in range(Constants.BRICK_COLS):
			var brick = _brick_template.instantiate()
			brick.position = Vector2(
				x * _brick_width + _brick_width / 2. - Constants.SCREEN_WIDTH / 2.,
				y * _brick_height + _brick_height / 2. - 22 * Constants.BRICK_ROWS
			)
			brick.set_score(2 ** ((Constants.BRICK_ROWS - y + 1) / 2 - 1))
			brick.set_color(_row_color[y])
			add_child(brick)
