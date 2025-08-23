extends Node2D

class_name GridOverlay

const CELL_SIZE = 48
const BOARD_WIDTH = 10
const BOARD_HEIGHT = 20
const BOARD_LEFT = -216
const BOARD_RIGHT = 216
const BOARD_BOTTOM = 457

var grid_lines = []
var show_grid = true

func _ready():
	create_grid()
	
func create_grid():
	# Calculate actual grid positions based on your game bounds
	var grid_width = (BOARD_RIGHT - BOARD_LEFT) / CELL_SIZE
	var grid_height = BOARD_BOTTOM / CELL_SIZE
	
	# Vertical lines - match your actual playable columns
	for x in range(int(grid_width) + 1):
		var line = Line2D.new()
		var x_pos = BOARD_LEFT + (x * CELL_SIZE)
		line.add_point(Vector2(x_pos, 0))
		line.add_point(Vector2(x_pos, BOARD_BOTTOM))
		line.width = 1
		line.default_color = Color(0.3, 0.3, 0.3, 0.5)
		add_child(line)
		grid_lines.append(line)
	
	# Horizontal lines - match your actual playable rows
	for y in range(int(grid_height) + 1):
		var line = Line2D.new()
		var y_pos = y * CELL_SIZE
		line.add_point(Vector2(BOARD_LEFT, y_pos))
		line.add_point(Vector2(BOARD_RIGHT, y_pos))
		line.width = 1
		line.default_color = Color(0.3, 0.3, 0.3, 0.5)
		add_child(line)
		grid_lines.append(line)

func toggle_grid():
	show_grid = !show_grid
	visible = show_grid

func set_grid_color(color: Color):
	for line in grid_lines:
		if line is Line2D:
			line.default_color = color
