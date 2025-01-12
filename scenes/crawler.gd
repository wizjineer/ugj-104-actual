extends Enemy

var snap_distance = 1  # Distance for snapping to the wall
var Velocity = Vector2()  # Velocity of the enemy
var move_direction = -1  # Start moving down by default
var ignore = false
var rotation_speed = 5  # Speed at which the enemy rotates (for smooth transition)
@onready var raycast = $RayCast2D  # Raycast to detect walls


func _direction_change():
	if is_on_wall():
		crawl()  # Crawl when on a wall

	if is_on_floor():
		rotation_degrees = 0  # Reset rotation to 0 when on the floor

	if !raycast.is_colliding() and !is_on_wall():
		# If raycast detects nothing and no.
		#t on a wall, crawl downwards
		move_direction = -1
		rotate_enemy(Vector2.DOWN)  # Rotate to face downward
		crawl()

func crawl():
	ignore = true
	# Check for wall or ceiling collision and adjust direction
	if is_on_ceiling() and move_direction == -1:
		# If it's moving down and hits the ceiling, switch to moving up
		move_direction = 1
		rotate_enemy(Vector2.UP)  # Rotate to face upwards
	elif is_on_floor() and move_direction == 1:
		# If it's moving up and hits the floor (bottom), switch to moving down
		move_direction = -1
		rotate_enemy(Vector2.DOWN)  # Rotate to face downwards

	# Apply velocity based on the direction
	velocity.y = move_direction * 10

	# Move the enemy using move_and_slide (this handles smooth movement and collisions)
	move_and_collide(velocity)  # Vector2.UP ensures gravity is applied correctly

	# Ensure the enemy is snapped to the grid after movement
	var snap_position = get_snap_position()
	position = snap_position  # Apply the snapping after movement

func get_snap_position():
	# This function calculates the snap position based on the wall's current position
	var snap_pos = position
	snap_pos.y = round(snap_pos.y / snap_distance) * snap_distance  # Snap to grid
	return snap_pos

func rotate_enemy(target_direction: Vector2):
	# Smooth rotation towards the target direction
	var target_angle = target_direction.angle()
	rotation = lerp_angle(rotation, target_angle, rotation_speed * get_process_delta_time())
