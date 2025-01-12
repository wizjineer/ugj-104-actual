extends Enemy

var snap_distance = 1  # Distance for snapping to the grid
var move_direction = -1  # Start moving down by default
var ignore = false
var rotation_speed = 5  # Speed at which the enemy rotates (for smooth transition)
@onready var raycast = $RayCast2D  # Raycast to detect walls
var grav_dir = "y"  # Gravity direction (y-axis by default)
var grav_direction = 1  # Direction of gravity (1 for downward or rightward, -1 for upward or leftward)

@onready var left_raycast = $left  # Raycast to detect left wall
@onready var right_raycast = $right  # Raycast to detect right wall

func _direction_change():
	if is_on_wall():
		crawl()  # Crawl when on a wall

	if is_on_floor():
		rotation_degrees = 0  # Reset rotation to 0 when on the floor
		velocity.x = 0

	if !raycast.is_colliding() and !is_on_wall() and !is_on_floor():
		# Rotate downward and crawl downwards when there's nothing below
		move_direction = -1
		crawl()

func crawl():
	ignore = true
	velocity.x = 0  # Stop horizontal movement

	if is_on_ceiling() and move_direction == -1:
		# Switch to moving up when hitting the ceiling
		move_direction = 1
		rotate_enemy(Vector2.UP)
	elif is_on_floor() and move_direction == 1:
		# Switch to moving down when hitting the floor
		move_direction = -1
		rotate_enemy(Vector2.DOWN)

	# Check if the enemy is on a wall
	if is_on_wall():
		# If on a wall, try to stick to the surface
		velocity = Vector2(0, move_direction * 10)
	velocity.x = 0
	move_and_collide(velocity)

	# Snap the enemy to the grid
	position = get_snap_position()

func get_snap_position():
	var snap_pos = position
	snap_pos.x = round(snap_pos.x / snap_distance) * snap_distance  # Snap horizontally
	snap_pos.y = round(snap_pos.y / snap_distance) * snap_distance  # Snap vertically
	return snap_pos

func rotate_enemy(target_direction: Vector2):
	# Rotate smoothly towards the target direction
	var target_angle = target_direction.angle()
	rotation = lerp_angle(rotation, target_angle, rotation_speed * get_process_delta_time())

func gravity_func():
	# Default gravity behavior when not on the wall or ceiling
	if not is_on_floor() and not is_on_ceiling() and not is_on_wall():
		if grav_dir == "y":
			velocity.y += lerp(velocity.y, grav_direction * gravity * get_process_delta_time(), 0.6)
	
	# If on a wall, gravity applies to the x-axis
	if is_on_wall():
		if left_raycast.is_colliding():
			# Gravity pulls left when on the left wall
			grav_dir = "x"
			grav_direction = -1  # Gravity pulls to the left
			velocity.x += lerp(velocity.x, grav_direction * gravity * get_process_delta_time(), 0.6)
		elif right_raycast.is_colliding():
			# Gravity pulls right when on the right wall
			grav_dir = "x"
			grav_direction = 1  # Gravity pulls to the right
			velocity.x += lerp(velocity.x, grav_direction * gravity * get_process_delta_time(), 0.6)
	
	# Handle gravity when on the ceiling (pulling upward)
	if is_on_ceiling():
		grav_dir = "y"
		grav_direction = -1  # Gravity pulls upward
		velocity.y += lerp(velocity.y, grav_direction * gravity * get_process_delta_time(), 0.6)

	# Handle gravity when on the floor (pulling downward)
	if is_on_floor():
		grav_dir = "y"
		grav_direction = 1  # Gravity pulls downward
		velocity.y += lerp(velocity.y, grav_direction * gravity * get_process_delta_time(), 0.6)

	# Ensure velocity isn't drifting away unnecessarily after transitions
	if is_on_wall() and not (left_raycast.is_colliding() or right_raycast.is_colliding()):
		# When transitioning off the wall, stop horizontal movement
		velocity.x = 0

	if is_on_floor() or is_on_ceiling():
		# Stop horizontal velocity when the player is on the floor or ceiling
		velocity.x = 0
