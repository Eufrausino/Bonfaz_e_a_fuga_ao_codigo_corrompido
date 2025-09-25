extends Control

var cena_do_jogo = "res://cenas/inicio.tscn"

func _ready() -> void:
	$"MarginContainer/VideoStreamPlayer".play()

func _input(event):
	if event is InputEventKey and event.is_pressed():
		get_tree().change_scene_to_file(cena_do_jogo)

func _on_video_stream_player_finished():
	print("O vídeo terminou. Mostrando o HUD.")
	get_tree().change_scene_to_file(cena_do_jogo)
	
