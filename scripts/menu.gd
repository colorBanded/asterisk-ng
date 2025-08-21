extends Control


func _on_buttonplay_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gamechoose.tscn")


func _on_buttonsettings_pressed() -> void:
	pass # Replace with function body.


func _on_buttonexit_pressed() -> void:
	get_tree().quit();
