extends Control

@onready var tris: Node = $tris
@onready var tale: Node = $tale
@onready var pong: Node = $pong

func _hidestupidnode(node):
	for child in node.get_children():
		if child is Label:
			child.hide()

#node.hide WHEN
func _showstupidnode(node):
	for child in node.get_children():
		if child is Label:
			child.show()

func _ready() -> void:
	_hidestupidnode(pong)
	_hidestupidnode(tris)
	_hidestupidnode(tale)
	if Properties.modeselected == 1:
		_showstupidnode(pong)
	elif Properties.modeselected == 2:
		_showstupidnode(tris)
	elif Properties.modeselected == 3:
		_showstupidnode(tale)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/gamechoose.tscn")
	if Input.is_action_just_pressed("enter"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
