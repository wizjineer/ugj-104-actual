extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var has_double_jumped = false

const DASH_SPEED = 900.0
var dashing = false
var can_dash = true
@export var health: int
var attacking = false
var cooldown = false
var attack = false

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("attack"):
		attacking = true
		cooldown = true
		$AnimationPlayer.play("new_animation")
		$attack_cooldown.start()
		$attack_durashan.start()
		
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif is_on_floor():
		has_double_jumped = false
	
	# Handle jump.
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = lerp(velocity.y, 0.0, 0.6)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif !has_double_jumped:
			velocity.y = JUMP_VELOCITY
			has_double_jumped = true

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Flip the character based on movement direction


	move_and_slide()
	var overlaping_bodies = $Area2D.get_overlapping_bodies()
	
	for body in overlaping_bodies:
		if body.is_in_group("enemies"):
			body.take_damage(2)
		
	 

func _on_area_2d_body_exited(body: Node2D) -> void:
	attack = false
