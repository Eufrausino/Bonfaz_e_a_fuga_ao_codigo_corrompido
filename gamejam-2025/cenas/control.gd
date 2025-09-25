extends Control


func _on_texture_button_pressed():
	# Troca para a cena do jogo
	print("Botão clicado!") # Teste inicial
	get_tree().change_scene_to_file("res://cenas/main.tscn")
