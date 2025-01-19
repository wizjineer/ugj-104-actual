extends Area2D

var enem_spawned = false
@export var enemy: PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players") and enem_spawned == false:
		enem_spawned = true
		var enemy_instance = enemy.instantiate()
		add_child(enemy_instance)
