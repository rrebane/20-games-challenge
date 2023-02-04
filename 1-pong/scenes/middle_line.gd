extends Control

@export var color: Color = Color.WHITE

func _draw():
	draw_dashed_line(
		Vector2(Constants.SCREEN_WIDTH / 2., -15),
		Vector2(Constants.SCREEN_WIDTH / 2., Constants.SCREEN_HEIGHT),
		color,
		10,
		30
	)
