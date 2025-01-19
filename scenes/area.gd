extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if ShipPieces.pieces > 11 and body.is_in_group("players"):
		get_tree().quit()
		
