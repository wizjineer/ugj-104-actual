extends CharacterBody2D

const Speed = 200

@export var player: Node2D
@onready var nav_agent = $NavigationAgent2D

func _physics_process(delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * Speed
	move_and_slide()
	
	
func make_path() -> void:
	nav_agent.target_position = player.global_position
	

func _on_timer_timeout() -> void:
	make_path()
