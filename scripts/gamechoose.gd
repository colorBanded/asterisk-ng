extends Control

@onready var modetitle: Label = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer/modetitle
@onready var modedesc: Label = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer/modedesc

@onready var ng: Button = $MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/ng
@onready var tris: Button = $MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer2/tris
@onready var tale: Button = $MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer3/tale

@onready var menu_bg: Sprite2D = $MenuBg
@onready var next: Button = $MarginContainer/HBoxContainer/VBoxContainer2/next

func _ready() -> void:
	modetitle.text = ".null"
	modedesc.text = "for a description, choose a mode."

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _doTween(identifier, fontSize, rate) -> void:
	var tween := get_tree().create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_method(
	func(size): identifier.add_theme_font_size_override("font_size", size),
	identifier.get_theme_font_size("font_size"),
	fontSize,
	rate
	)
# Color.from_rgba8(24, 25, 255,30)
func _doColorTween(r, g, b, a) -> void:
	var tween := get_tree().create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(
		menu_bg,
		"modulate",
		Color.from_rgba8(r, g, b,a),
		0.5
	)

func _on_ng_mouse_entered() -> void:
	modetitle.text = "NG"
	modedesc.text = "for the twenty six hundred."
	modetitle.add_theme_font_override("font", preload("res://assets/FOT-NewRodin Pro EB.otf"))
	_doTween(ng,48,0.3)
	_doTween(tris,26,0.3)
	_doTween(tale,26,0.3)
	_doColorTween(24,25,255,30)

func _on_tris_mouse_entered() -> void:
	modetitle.text = "TRIS"
	modedesc.text = "for the elektronica sixty."
	modetitle.add_theme_font_override("font", preload("res://assets/FOT-NewRodin Pro EB.otf"))
	_doTween(ng,26,0.3)
	_doTween(tris,48,0.3)
	_doTween(tale,26,0.3)
	_doColorTween(24,255,182,30)

func _on_tale_mouse_entered() -> void:
	modetitle.text = "TALE"
	modetitle.add_theme_font_override("font", preload("res://assets/MonsterFriend2Back.otf"))
	modedesc.text = "for I, UNDYNE, will strike you down!"
	_doTween(ng,26,0.3)
	_doTween(tris,26,0.3)
	_doTween(tale,48,0.3)
	_doColorTween(255,24,24,30)


func _on_ng_focus_entered() -> void:
	modetitle.text = "NG"
	modedesc.text = "for the twenty six hundred."
	modetitle.add_theme_font_override("font", preload("res://assets/FOT-NewRodin Pro EB.otf"))
	_doTween(ng,48,0.3)
	_doTween(tris,26,0.3)
	_doTween(tale,26,0.3)



func _on_tris_focus_entered() -> void:
	modetitle.text = "TRIS"
	modedesc.text = "for the elektronica sixty."
	modetitle.add_theme_font_override("font", preload("res://assets/FOT-NewRodin Pro EB.otf"))
	_doTween(ng,26,0.3)
	_doTween(tris,48,0.3)
	_doTween(tale,26,0.3)


func _on_tale_focus_entered() -> void:
	modetitle.text = "TALE"
	modetitle.add_theme_font_override("font", preload("res://assets/MonsterFriend2Back.otf"))
	modedesc.text = "for I, UNDYNE, will strike you down!"
	_doTween(ng,26,0.3)
	_doTween(tris,26,0.3)
	_doTween(tale,48,0.3)



func _on_next_pressed() -> void:
	if Properties.modeselected < 1 or Properties.modeselected > 3:
		pass
	else:
		get_tree().change_scene_to_file("res://scenes/controlmenu.tscn")


func _on_ng_pressed() -> void:
	Properties.modeselected = 1
	next.text = "next: *ng"

func _on_tris_pressed() -> void:
	Properties.modeselected = 2
	next.text = "next: *tris"

func _on_tale_pressed() -> void:
	Properties.modeselected = 3
	next.text = "next: *tale"
