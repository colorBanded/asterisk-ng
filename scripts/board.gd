extends Node
class_name Board

signal tetrimono_locked
signal game_over
signal skyline_reached

@export var tetrimono_scene: PackedScene
const ROW_COUNT = 20
const COLUMN_COUNT = 10
const CELL_SIZE = 48

@export var spawn_offset: Vector2 = Vector2.ZERO

var tetrimonos: Array = []
var next_tetrimono
var is_game_over = false

@onready var line_scene = preload("res://Scenes/line.tscn")
@export var panel_container: PanelContainer

const ui = preload("res://scenes/ui.tscn")

func get_lines():
	return get_children().filter(func(c): return c is Line)

func remove_full_lines():
	var lines_to_remove = []

	for line in get_lines():
		if line.is_line_full(COLUMN_COUNT):
			lines_to_remove.append(line)

	if lines_to_remove.is_empty():
		return

	lines_to_remove.sort_custom(func(a, b): return a.global_position.y > b.global_position.y)

	for line in lines_to_remove:
		var removed_y = line.global_position.y
		line.queue_free()
		
		await get_tree().process_frame
		
		for remaining_line in get_lines():
			if remaining_line.global_position.y < removed_y:
				remaining_line.global_position.y += CELL_SIZE

func move_lines_down(y_position):
	for line in get_lines():
		if line.global_position.y < y_position:
			line.global_position.y += CELL_SIZE

func get_all_pieces():
	var pieces = []
	for line in get_lines():
		pieces.append_array(line.get_children())
	return pieces

func spawn_tetrimono(type: Properties.tetrimono, is_next_piece: bool, spawn_position = null):
	if is_game_over:
		return

	var tetrimono_data = Properties.data[type]
	var tetrimono = tetrimono_scene.instantiate() as Tetrimono
	tetrimono.tetrimono_data = tetrimono_data
	tetrimono.is_next_piece = is_next_piece

	if is_next_piece == false:
		var other_pieces = get_all_pieces()
		var actual_spawn_position: Vector2 = Vector2(3 * CELL_SIZE, 0)

		if spawn_position != null and spawn_position != Vector2.ZERO:
			actual_spawn_position = spawn_position
		elif tetrimono_data != null and tetrimono_data.spawn_position != null:
			actual_spawn_position = tetrimono_data.spawn_position

		tetrimono.position = actual_spawn_position
		tetrimono.other_tetrimonoes_pieces = other_pieces
		tetrimono.lock_tetrimono.connect(on_tetrimono_locked)

		if check_spawn_collision(tetrimono, actual_spawn_position):
			is_game_over = true
			game_over.emit()
			tetrimono.queue_free()
			return

		add_child.call_deferred(tetrimono)
	else:
		tetrimono.scale = Vector2(0.5, 0.5)
		panel_container.add_child.call_deferred(tetrimono)
		var next_piece_position: Vector2 = Vector2(100, 50)
		if spawn_position != null and spawn_position != Vector2.ZERO:
			next_piece_position = spawn_position
		tetrimono.set_position(next_piece_position)
		next_tetrimono = tetrimono

func check_spawn_collision(tetrimono: Tetrimono, spawn_pos: Vector2) -> bool:
	var existing_pieces = get_all_pieces()

	for piece in tetrimono.pieces:
		var world_pos = spawn_pos + piece.position

		for existing_piece in existing_pieces:
			if not is_instance_valid(existing_piece):
				continue
			if world_pos.distance_to(existing_piece.global_position) < CELL_SIZE * 0.5:
				return true

	return false

func on_tetrimono_locked(tetrimono: Tetrimono):
	if is_game_over:
		return

	if next_tetrimono and is_instance_valid(next_tetrimono):
		next_tetrimono.queue_free()

	tetrimonos.append(tetrimono)
	
	if check_skyline_reached(tetrimono):
		skyline_reached.emit()
		print("Skyline reached!")
		return
	
	add_tetrimono_to_lines(tetrimono)
	await remove_full_lines()

	if check_game_over_after_lock(tetrimono):
		is_game_over = true
		game_over.emit()
		return

	tetrimono_locked.emit()

func check_skyline_reached(locked_tetrimono: Tetrimono) -> bool:
	var skyline_y = 2 * CELL_SIZE

	for piece in locked_tetrimono.pieces:
		if not is_instance_valid(piece):
			continue
		var piece_world_y = locked_tetrimono.global_position.y + piece.position.y
		if piece_world_y <= skyline_y:
			return true

	return false

func check_game_over_after_lock(locked_tetrimono: Tetrimono) -> bool:
	var skyline_y = 2 * CELL_SIZE

	for piece in locked_tetrimono.pieces:
		if not is_instance_valid(piece):
			continue
		var piece_world_y = locked_tetrimono.global_position.y + piece.position.y
		if piece_world_y <= skyline_y:
			print("Game over: piece locked above skyline at y: ", piece_world_y)
			return true

	return false

func add_tetrimono_to_lines(tetrimono: Tetrimono):
	var tetrimono_pieces = tetrimono.get_children().filter(func (c): return c is Piece)

	for piece in tetrimono_pieces:
		var y_position = piece.global_position.y
		var does_line_for_piece_exists = false

		for line in get_lines():
			if line.global_position.y == y_position:
				piece.reparent(line)
				does_line_for_piece_exists = true
				break

		if !does_line_for_piece_exists:
			var piece_line = line_scene.instantiate() as Line
			piece_line.global_position = Vector2(0, y_position)
			add_child(piece_line)
			piece.reparent(piece_line)
