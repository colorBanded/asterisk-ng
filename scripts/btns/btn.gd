extends Button
func _process(delta):
	position.x += (get_global_mouse_position().x/2*delta)-position.x

	position.y += (get_global_mouse_position().y/2*delta)-position.y
