extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var has_double_jumped = false

const DASH_SPEED = 900.0
var dashing = false
var can_dash = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif is_on_floor():
		has_double_jumped = false
	
	# Handle jump.
	if Input.is_action_just_released("jump") && velocity.y < 0:
		velocity.y = lerp(velocity.y, 0.0, 0.6)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif !has_double_jumped:
			velocity.y = JUMP_VELOCITY
			has_double_jumped = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_dash_timer_timeout() -> void:
	dashing = false # Replace with function body.


func _on_dash_cooldown_timeout() -> void:
	can_dash = true # Replace with function body.
