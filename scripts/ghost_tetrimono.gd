extends Node2D
class_name GhostTetrimono

@onready var piece_scene = preload("res://scenes/piece.tscn")
const ghost_texture = preload("res://monos/ghost.png")

var tetrimono_data: Resource



func _ready():
	var tetrimono_cells = Properties.cells[tetrimono_data.tetrimono_type]
	
	for cell in tetrimono_cells:
		var piece = piece_scene.instantiate() as Piece
		add_child(piece)
		piece.set_texture(ghost_texture)
		piece.position = cell * piece.get_size()

func set_ghost_tetrimono(new_position: Vector2, pieces_position):
	global_position = new_position
	
	var pieces = get_children()
	for i in pieces.size():
		pieces[i].position = pieces_position[i]
