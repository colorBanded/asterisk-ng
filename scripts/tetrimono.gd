extends Node2D

class_name Tetrimono

signal lock_tetrimono(tetrimono: Tetrimono)

var bounds = {
	"min_x": -235,
	"max_x": 39,
	"max_y": 474
}

var rotation_index = 0
var wall_kicks
var tetrimono_data
var is_next_piece
var pieces = []
var other_tetrimonoes_pieces = [] 
var ghost_tetrimono

@onready var timer = $Timer
@onready var piece_scene = preload("res://Scenes/piece.tscn")
@onready var ghost_tetrimono_scene = preload("res://scenes/ghost_tetrimono.tscn")

var tetrimono_cells

func _ready():
	if tetrimono_data == null:
		print("Error: tetrimono_data is null in _ready()")
		return

	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)

	var original_cells = Properties.cells[tetrimono_data.tetrimono_type]
	tetrimono_cells = []
	for cell in original_cells:
		tetrimono_cells.append(cell)

	print("Spawning tetrimono type: ", tetrimono_data.tetrimono_type)
	print("Available types: ", Properties.tetrimono.values())
	print("Cells: ", tetrimono_cells)

	for cell in tetrimono_cells:
		var piece = piece_scene.instantiate() as Piece
		pieces.append(piece)
		add_child(piece)
		piece.set_texture(tetrimono_data.piece_texture)
		piece.position = cell * piece.get_size()

	if is_next_piece == false:
		position = tetrimono_data.spawn_position	
		wall_kicks = Properties.wall_kicks_i if tetrimono_data.tetrimono_type == Properties.tetrimono.I else Properties.wall_kicks_jlostz
		ghost_tetrimono = ghost_tetrimono_scene.instantiate() as GhostTetrimono
		ghost_tetrimono.tetrimono_data = tetrimono_data
		get_tree().root.add_child.call_deferred(ghost_tetrimono)
		hard_drop_ghost.call_deferred()

		print("Starting timer for falling piece")
		timer.start()
		set_process_input(true)
	else: 
		print("Next piece - stopping timer and disabling input")
		timer.stop()
		set_process_input(false)

func hard_drop_ghost():
	var final_hard_drop_position
	var ghost_position_update = calculate_global_position(Vector2.DOWN, global_position)

	while ghost_position_update != null:
		ghost_position_update = calculate_global_position(Vector2.DOWN, ghost_position_update)
		if ghost_position_update != null:
			final_hard_drop_position = ghost_position_update

	if final_hard_drop_position != null:
		var children = get_children().filter(func (c): return c is Piece)

		var pieces_position = []

		for i in children.size():
			var piece_position = children[i].position
			pieces_position.append(piece_position)

		ghost_tetrimono.set_ghost_tetrimono(final_hard_drop_position, pieces_position)

	return final_hard_drop_position

func _input(_event):
	if Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
	elif Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)
	elif Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_just_pressed("hard_drop"):
		hard_drop()
	elif Input.is_action_just_pressed("rotate_left"):
		rotate_tetrimono(-1)
	elif Input.is_action_just_pressed("rotate_right"):
		rotate_tetrimono(1)

func move(direction: Vector2) -> bool:
	var new_position = calculate_global_position(direction, global_position)
	if new_position:
		global_position = new_position
		if direction != Vector2.DOWN:
			hard_drop_ghost.call_deferred()
		return true
	return false

func calculate_global_position(direction: Vector2, starting_global_position: Vector2):
	if is_colliding_with_other_tetrimonos(direction, starting_global_position):
		return null

	if !is_within_game_bounds(direction, starting_global_position):
		return null
	return starting_global_position + direction * pieces[0].get_size().x

func is_within_game_bounds(direction: Vector2, starting_global_position: Vector2) -> bool:
	var piece_size = pieces[0].get_size().x
	var new_tetrimono_position = starting_global_position + direction * piece_size
	
	for piece in pieces:
		var final_piece_position = new_tetrimono_position + piece.position
		
		if final_piece_position.x < bounds.min_x or \
		   final_piece_position.x > bounds.max_x or \
		   final_piece_position.y > bounds.max_y:
			return false
	return true

func is_colliding_with_other_tetrimonos(direction: Vector2, starting_global_position: Vector2):
	var piece_size = pieces[0].get_size().x
	var new_tetrimono_position = starting_global_position + direction * piece_size
	
	for tetrimono_piece in other_tetrimonoes_pieces:
		if !is_instance_valid(tetrimono_piece):
			continue
		for piece in pieces:
			var final_piece_position = new_tetrimono_position + piece.position
			if final_piece_position == tetrimono_piece.global_position:
				return true
	return false

func is_on_ground() -> bool:
	for piece in pieces:
		var final_piece_position = global_position + piece.position
		if final_piece_position.y >= bounds.max_y:
			return true
	
	var piece_size = pieces[0].get_size().x
	var test_position = global_position + Vector2.DOWN * piece_size
	
	for tetrimono_piece in other_tetrimonoes_pieces:
		if !is_instance_valid(tetrimono_piece):
			continue
		for piece in pieces:
			var final_piece_position = test_position + piece.position
			if final_piece_position == tetrimono_piece.global_position:
				return true
	
	return false

func rotate_tetrimono(direction: int):
	if tetrimono_data.tetrimono_type == Properties.tetrimono.O:
		return

	var original_rotation_index = rotation_index
	var original_cells = []
	for cell in tetrimono_cells:
		original_cells.append(cell)

	apply_rotation(direction)
	rotation_index = wrap(rotation_index + direction, 0, 4)

	if !is_within_game_bounds(Vector2.ZERO, global_position) or \
	   is_colliding_with_other_tetrimonos(Vector2.ZERO, global_position):
		
		if !test_wall_kicks(rotation_index, direction):
			rotation_index = original_rotation_index
			tetrimono_cells = original_cells
			
			for i in pieces.size():
				pieces[i].position = tetrimono_cells[i] * pieces[i].get_size()

	hard_drop_ghost.call_deferred()

func test_wall_kicks(rotation_index: int, rotation_direction: int):
	var wall_kick_index = get_wall_kick_index(rotation_index, rotation_direction)
	
	for i in wall_kicks[wall_kick_index].size():
		var translation = wall_kicks[wall_kick_index][i]
		var test_position = global_position + translation * pieces[0].get_size().x
		
		if is_within_game_bounds(Vector2.ZERO, test_position) and \
		   !is_colliding_with_other_tetrimonos(Vector2.ZERO, test_position):
			global_position = test_position
			return true
	
	return false

func get_wall_kick_index(rotation_index: int, rotation_direction):
	var wall_kick_index = rotation_index * 2
	if rotation_direction < 0:
		wall_kick_index -= 1

	return wrap(wall_kick_index, 0 , wall_kicks.size())

func apply_rotation(direction: int):
	var rotation_matrix = Properties.clockwise_rotation_matrix if direction == 1 else Properties.counter_clockwise_rotation_matrix

	for i in tetrimono_cells.size():
		var cell = tetrimono_cells[i]
		
		var new_x = rotation_matrix[0].x * cell.x + rotation_matrix[0].y * cell.y
		var new_y = rotation_matrix[1].x * cell.x + rotation_matrix[1].y * cell.y
		
		tetrimono_cells[i] = Vector2(new_x, new_y)

	for i in pieces.size():
		pieces[i].position = tetrimono_cells[i] * pieces[i].get_size()

func hard_drop():
	while(move(Vector2.DOWN)):
		continue
	lock()

func lock():
	timer.stop()
	lock_tetrimono.emit(self)
	set_process_input(false)
	ghost_tetrimono.queue_free()

func _on_timer_timeout():
	if is_on_ground():
		lock()
		return
	
	var can_move_down = move(Vector2.DOWN)
	if not can_move_down:
		lock()
