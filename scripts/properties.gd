extends Node


var modeselected
var highestScore: int = 0
var highscore: int = 0
var newgame
var gamestarted



enum tetrimono {
	I,O,T,J,L,S,Z
}

# coordinates are such a pain
var cells = {
	tetrimono.I: [Vector2(-1,0), Vector2(0,0), Vector2(1,0), Vector2(2,0)],
	tetrimono.J: [Vector2(-1,1), Vector2(-1,0), Vector2(0,0), Vector2(1,0)],
	tetrimono.L: [Vector2(1,1), Vector2(-1,0), Vector2(0,0), Vector2(1,0)],
	tetrimono.O: [Vector2(0,1), Vector2(1,1), Vector2(0,0), Vector2(1,0)], # Fixed this line
	tetrimono.S: [Vector2(0,1), Vector2(1,1), Vector2(-1,0), Vector2(0,0)],
	tetrimono.T: [Vector2(0,1), Vector2(-1,0), Vector2(0,0), Vector2(1,0)],
	tetrimono.Z: [Vector2(-1,1), Vector2(0,1), Vector2(0,0), Vector2(1,0)]
}

var wall_kicks_i = [
	[Vector2(0,0), Vector2(-2,0), Vector2(1,0),Vector2(-2,-1), Vector2(1,2)],
	[Vector2(0,0), Vector2(2,0), Vector2(-1,0), Vector2(2,1), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(2,0), Vector2(-1,2), Vector2(2, -1)],
	[Vector2(0,0), Vector2(1,0), Vector2(-2,0), Vector2(1,-2), Vector2(-2, 1)],
	[Vector2(0,0), Vector2(2,0), Vector2(-1,0), Vector2(2,1), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(-2,0), Vector2(1,0), Vector2(-2, -1), Vector2(1, 2)],
	[Vector2(0,0), Vector2(1,0), Vector2(-2,0), Vector2(1, -2), Vector2(-2,1)],
	[Vector2(0,0), Vector2(-1, 0), Vector2(2,0), Vector2(-1,2), Vector2(2, -1)]
]

var wall_kicks_jlostz = [
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,1), Vector2(0,-2), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1, -1), Vector2(0,2), Vector2(1, 2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1,-1), Vector2(0,2), Vector2(1, 2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,1), Vector2(0, -2), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,-2), Vector2(1, -2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1, -1), Vector2(0,2), Vector2(-1, 2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0,2), Vector2(-1, 2)],
	[Vector2(0,0), Vector2(1, 0), Vector2(1, 1), Vector2(0,-2), Vector2(1, -2)]
]

var data = {
	tetrimono.I: preload("res://res/i_piece_data.tres"),
	tetrimono.J: preload("res://res/j_piece_data.tres"),
	tetrimono.L: preload("res://res/l_piece_data.tres"),
	tetrimono.O: preload("res://res/o_piece_data.tres"),
	tetrimono.S: preload("res://res/s_piece_data.tres"),
	tetrimono.T: preload("res://res/t_piece_data.tres"),
	tetrimono.Z: preload("res://res/z_piece_data.tres"),
}

var clockwise_rotation_matrix = [Vector2(0, -1), Vector2(1, 0)]
var counter_clockwise_rotation_matrix = [Vector2(0,1), Vector2(-1, 0)]
