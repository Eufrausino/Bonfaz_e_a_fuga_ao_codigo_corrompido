extends Area2D

func _on_body_entered(body):
	if body.name == "bomfim": # ou body.is_in_group("player")
		get_tree().change_scene_to_file("res://game_over_scene.tscn")
