extends Node

var current_tetrimono_type
var next_tetrimono_type 
var next_tetrimono_node  

signal tetrimono_locked
signal game_over

const ROW_COUNT = 10
const COLUMN_COUNT = 20

var tetrimonos: Array[Tetrimono] = []

@export var tetrimono_scene: PackedScene


@onready var ui: UI = $"../Ui"

@onready var panel_container: PanelContainer = $"../PanelContainer"
@onready var board = $"../Board" as Board

var is_game_over = false

func _ready():

	current_tetrimono_type = get_random_tetrimono_type()
	next_tetrimono_type = get_random_tetrimono_type()


	board.spawn_tetrimono(current_tetrimono_type, false, null)

	board.spawn_tetrimono(next_tetrimono_type, true, Vector2(100, 50))

	await get_tree().process_frame
	next_tetrimono_node = board.next_tetrimono

	board.tetrimono_locked.connect(on_tetrimono_locked)
	board.game_over.connect(on_game_over)

func get_random_tetrimono_type():
	var types = [
		Properties.tetrimono.I,
		Properties.tetrimono.J,
		Properties.tetrimono.L,
		Properties.tetrimono.O,
		Properties.tetrimono.S,
		Properties.tetrimono.T,
		Properties.tetrimono.Z
	]
	return types.pick_random()

func on_tetrimono_locked():
	if is_game_over:
		return

	if next_tetrimono_node and is_instance_valid(next_tetrimono_node):

		next_tetrimono_node.queue_free()

	current_tetrimono_type = next_tetrimono_type
	next_tetrimono_type = get_random_tetrimono_type()


	board.spawn_tetrimono(current_tetrimono_type, false, null)

	board.spawn_tetrimono(next_tetrimono_type, true, Vector2(100, 50))

	await get_tree().process_frame
	next_tetrimono_node = board.next_tetrimono
	print("New next tetrimono node: ", next_tetrimono_node)

func on_game_over():
	is_game_over = true
	ui.show_game_over()
