extends Control
@onready var modetitle: Label = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer/modetitle
@onready var modedesc: Label = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer/modedesc


func _ready() -> void:
	modetitle.text = ".null"
	modedesc.text = "for a description, choose a mode."



func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")




func _on_ng_mouse_entered() -> void:
	modetitle.text = "NG"
	modedesc.text = "for the twenty six hundred."
	modetitle.add_theme_font_override("font", preload("res://assets/FOT-NewRodin Pro EB.otf"))


func _on_tris_mouse_entered() -> void:
	modetitle.text = "TRIS"
	modedesc.text = "for the elektronica sixty."
	modetitle.add_theme_font_override("font", preload("res://assets/FOT-NewRodin Pro EB.otf"))


func _on_tale_mouse_entered() -> void:
	modetitle.text = "TALE"
	modetitle.add_theme_font_override("font", preload("res://assets/MonsterFriend2Back.otf"))
	modedesc.text = "for I, UNDYNE, will strike you down!"
