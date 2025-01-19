extends CharacterBody2D

class_name Enemy

@export var resource: Resource
@export var speed: float = 100.0
@export var gravity: float = 500.0
var direction: int = 1
@onready var ground_check = $RayCast2D
@onready var sprite = $Sprite2D
var health: int
var damage: int
var attacked = false

func _ready() -> void:
	sprite.texture = resource.texture
	health = resource.health
	damage = resource.dammadge

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	gravity_func()
		
	# Set horizontal movement
	velocity.x = direction * speed
	
	# Move and handle collisions
	move_and_slide()
	
	# Check if hitting a wall or leaving the platform
	_direction_change()


func update_raycast_position():
	# Update the cast_to property of RayCast2D to match the direction
	ground_check.position = Vector2(direction * 50, 10)

func _direction_change():
	if !ground_check.is_colliding() or is_on_wall():
		direction *= -1
		update_raycast_position()

func take_damage(amount: int) -> void:
	if !attacked:
		health -= amount
		if health <= 0:
			_die()
		attacked = true
		$imunity_timer.start()

func _die() -> void:
	ShipPieces.add_piece()
	queue_free()

func gravity_func():
	if not is_on_floor() and not is_on_wall() and not is_on_ceiling():
		velocity.y += lerp(velocity.y, gravity * get_process_delta_time(), 0.6)
	

func _on_imunity_timer_timeout() -> void:
	attacked = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		var knockback_dir = (global_position - body.global_position).normalized()
		var knockback_strength = 300.0
		body.take_damage(1, knockback_dir, knockback_strength)
