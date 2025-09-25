extends Control

var cena_do_jogo = "res://cenas/inicio.tscn"

func _ready() -> void:
	$HUD.hide()
	print(Dados.placar_final)
	if(Dados.placar_final == 0):
		$"MarginContainer/0Pontos".play()
	if (Dados.placar_final == 25):
		$"MarginContainer/25Pontos".play()
	if (Dados.placar_final == 50):
		$"MarginContainer/50Pontos".play()
	if (Dados.placar_final == 75):
		$"MarginContainer/75Pontos".play()
	if (Dados.placar_final == 100):
		$"MarginContainer/100Pontos".play()

func _input(event):
	if event is InputEventKey and event.is_pressed():
			Dados.placar_final = 0
			get_tree().change_scene_to_file(cena_do_jogo)

func _on_video_stream_player_finished():
	print("O vídeo terminou. Mostrando o HUD.")
	
	$HUD.show()
	$MarginContainer.hide()
	
