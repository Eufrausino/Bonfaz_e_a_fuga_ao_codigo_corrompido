extends Node2D
@export var points := 1

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"): # ou verifique se é o Player
		body.add_score(points)     # função do player para somar pontos
		queue_free()               # remove o item da cena
