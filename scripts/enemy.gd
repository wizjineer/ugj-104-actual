extends CharacterBody2D

@export var speed: float = 100.0
@export var gravity: float = 500.0
var direction: int = 1
@onready var ground_check = $RayCast2D

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += lerp(velocity.y, gravity * delta, 0.6)
		
	# Set horizontal movement
	velocity.x = direction * speed
	
	# Move and handle collisions
	move_and_slide()
	
	# Check if hitting a wall or leaving the platform
	if is_on_wall() or !ground_check.is_colliding():
		direction *= -1  # Flip direction
		update_raycast_position()

func update_raycast_position():
	# Update the cast_to property of RayCast2D to match the direction
	ground_check.position = Vector2(direction * 50, 10)
