extends Area2D

func _process(delta: float) -> void:
	# Get the mouse position in global coordinates
	var mouse_pos = get_global_mouse_position()

	# Get the direction vector from the Area2D to the mouse position
	var direction = mouse_pos - global_position

	# Calculate the angle to the mouse position
	var angle_to_mouse = direction.angle()

	# Set the rotation to face the mouse (inverted to make it face correctly)
	rotation = angle_to_mouse  # Correct the angle inversion by inverting it

func is_facing_down() -> bool:
	return rotation_degrees > -135 or rotation_degrees < 135
