extends Area2D

@onready var sprite = $Sprite  # Assuming you have a Sprite node as a child

func _process(delta: float) -> void:
	# Get the mouse position in global coordinates
	var mouse_pos = get_global_mouse_position()

	# Get the direction vector from the Area2D to the mouse position
	var direction = mouse_pos - global_position

	# Calculate the angle to the mouse position
	var angle_to_mouse = direction.angle()

	# Set the rotation to face the mouse (inverted to make it face correctly)
	rotation = angle_to_mouse  # Correct the angle inversion by inverting it

	# Check if sprite needs to be flipped based on rotation
	# If the angle is greater than 90 degrees or less than -90 degrees, flip the sprite
	#if (rotation > deg_to_rad(90) or rotation < deg_to_rad(-90)):
		#scale.x = -1  # Flip sprite horizontally
	#else:
		#scale.x = 1  # Face forward (not flipped)

func is_facing_down() -> bool:
	return rotation > deg_to_rad(135) or rotation < deg_to_rad(-135)
