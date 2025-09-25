extends Node

var virus1 = preload("res://cenas/virus.tscn")
var virus2 = preload("res://cenas/virus_2.tscn")
var gameOverScene = "res://cenas/game_over_scene.tscn"
var tipos_obstaculos := [virus1, virus2]
var obstaculos : Array
var virusHeights := [215, 390]
var ultimoObstaculo
var ultimaParede
var ultimaPlataforma

var placar: int
var alturaChao : int

const BOMFIM_POS_INICIAL:= Vector2i(520,510)
const CAM_POS_INICIAL:= Vector2i(576,324)

var velocidade_bomfim : float
const VELOCIDDADE_INICIAL : float = 7.0
#const MAX_VELOCIDADE: int =  50.0

const POS_CHAO:= Vector2i(2,6)

var velocidade_onda:float
var tam_tela : Vector2i

var game_running : bool

var Plataforma = preload("res://cenas/plataforma.tscn")
var Parede = preload("res://cenas/parede.tscn")
var Pergaminho = preload("res://cenas/pergaminho.tscn")

var plataformas : Array
var plataformasHeights := [420, 300]
var paredes : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tam_tela = get_window().size
	alturaChao = $Chao.get_node("chao1").texture.get_height()
	Engine.max_fps = 60
	velocidade_bomfim = VELOCIDDADE_INICIAL
	novo_jogo()

func novo_jogo():
	placar = 0
	$bomfim.position = BOMFIM_POS_INICIAL
	$bomfim.velocity = Vector2i(0,0)
	$Camera2D.position =  CAM_POS_INICIAL
	$Chao.position = POS_CHAO
	velocidade_bomfim = VELOCIDDADE_INICIAL
	game_running = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#if game_running == true:
		#$"Fundo/background_music".play()
	
	gerar_obstaculo()
	gerar_platorma()
	gerar_parede()
	
	$bomfim.position.x += velocidade_bomfim
	$Camera2D.position.x += velocidade_bomfim
	
	#aumentar meu placar -> O plcar está aumentando 
	# de acordo com o movimento do jogador pela tela
	#print(placar) 
	mostrar_placar()
	
	velocidade_onda = velocidade_bomfim - 5
	$Ondas.position.x += velocidade_bomfim
	
	if $Camera2D.position.x - $Chao.position.x > tam_tela.x * 1.5:
		$Chao.position.x += tam_tela.x
	
	for obs in obstaculos:
		if obs.position.x < ($Camera2D.position.x - tam_tela.x):
			removerObstaculo(obs)
	for plat in plataformas:
		if plat.position.x < ($Camera2D.position.x - tam_tela.x):
			removerPlataforma(plat)
	for par in paredes:
		if par.position.x < ($Camera2D.position.x - tam_tela.x):
			removerParedes(par)

func gerar_obstaculo():
	var margem_saida_da_tela = 50 

	if obstaculos.is_empty() or ultimoObstaculo.position.x < ($Camera2D.position.x - tam_tela.x / 2) - margem_saida_da_tela:
		if ultimaParede != null and ultimaPlataforma != null:
			if ultimaPlataforma.position.x < ($Camera2D.position.x + tam_tela.x / 2):
				if ultimaParede.position.x < ($Camera2D.position.x + tam_tela.x / 2):
					var tipoObstaculo = tipos_obstaculos[randi() % tipos_obstaculos.size()]
					var obstaculo = tipoObstaculo.instantiate()
					
					var obstaculo_x : int = $Camera2D.position.x + (tam_tela.x / 2) + randi_range(100, 400)
					var obstaculo_y : int
					if tipoObstaculo == virus1:
						obstaculo_y = virusHeights[randi() % virusHeights.size()] - 20
					else:
						obstaculo_y = virusHeights[randi() % virusHeights.size()]
						
					ultimoObstaculo = obstaculo
					adiciona_obstaculo(obstaculo, obstaculo_x, obstaculo_y)
		else:
			var tipoObstaculo = tipos_obstaculos[randi() % tipos_obstaculos.size()]
			var obstaculo = tipoObstaculo.instantiate()
			
			var obstaculo_x : int = $Camera2D.position.x + (tam_tela.x / 2) + randi_range(100, 400)
			var obstaculo_y : int
			if tipoObstaculo == virus1:
				obstaculo_y = virusHeights[randi() % virusHeights.size()] - 20
			else:
				obstaculo_y = virusHeights[randi() % virusHeights.size()]
				
			ultimoObstaculo = obstaculo
			adiciona_obstaculo(obstaculo, obstaculo_x, obstaculo_y)
		
func adiciona_obstaculo(obstaculo, x, y):
	obstaculo.position = Vector2i(x, y)
	obstaculo.body_entered.connect(colisaoObstaculo)
	add_child(obstaculo)
	obstaculos.append(obstaculo)

func colisaoObstaculo(body):
	if body.is_in_group("jogador"):
		game_over()

func game_over():
	if (Dados.placar_final != 100):
		$"bomfim/morte".play()
	get_tree().paused = true
	game_running = false
	await $"bomfim/morte".finished
	Dados.placar_final = placar
	get_tree().paused = false
	get_tree().change_scene_to_file(gameOverScene)

func removerObstaculo(obs):
	obs.queue_free()
	obstaculos.erase(obs)

func gerar_platorma():
	var margem_saida_da_tela = 50 
	if plataformas.is_empty() or ultimaPlataforma.position.x < ($Camera2D.position.x + tam_tela.x / 2) - margem_saida_da_tela:
		
		#var tipoObstaculo = tipos_obstaculos[randi() % tipos_obstaculos.size()]
		#var obstaculo = tipoObstaculo.instantiate()
		var plataforma = Plataforma.instantiate()
		var x : int = $Camera2D.position.x + (tam_tela.x / 2) + randi_range(100, 500)
		var y : int = plataformasHeights[randi() % plataformasHeights.size()]
		
		var pergaminho = Pergaminho.instantiate()
		var y_per = y - 33
		
		ultimaPlataforma = plataforma
		adiciona_plataforma(plataforma, x, y)
		if (randi_range(0, 100) < 15):
			adiciona_pergaminho(pergaminho, x, y_per)
		
func adiciona_plataforma(plataforma, x, y):
	plataforma.position = Vector2i(x, y)
	add_child(plataforma)
	plataformas.append(plataforma)

func removerPlataforma(plataforma):
	plataforma.queue_free()
	plataformas.erase(plataforma)
	
func adiciona_pergaminho(pergaminho, x, y):
	pergaminho.position = Vector2i(x, y)
	pergaminho.body_entered.connect(colisaoPergaminho.bind(pergaminho))
	add_child(pergaminho)

func colisaoPergaminho(body, pergaminho):
	if body.is_in_group("jogador"):
		Dados.placar_final += 25
		placar = Dados.placar_final
		mostrar_placar()
		pergaminho.queue_free()
		$"bomfim/coin".play()
		velocidade_bomfim += placar * 0.123
		print("Velocidade: " + str(velocidade_bomfim))
		if(placar == 100):
			print("teste")
			game_over()
		
func gerar_parede():
	var margem_saida_da_tela = 50
	if paredes.is_empty() or ultimaParede.position.x < ($Camera2D.position.x + tam_tela.x / 2) - margem_saida_da_tela:
		if ultimaPlataforma.position.x < ($Camera2D.position.x + tam_tela.x / 2):
			if ultimoObstaculo.position.x < ($Camera2D.position.x + tam_tela.x / 2):
				var parede = Parede.instantiate()
				var x : int = $Camera2D.position.x + (tam_tela.x / 2) + randi_range(200, 1000)
				
				ultimaParede = parede     
				adiciona_parede(parede, x)
		
func adiciona_parede(parede, x):
	parede.position = Vector2i(x,475)
	add_child(parede)
	paredes.append(parede)

func removerParedes(parede):
	parede.queue_free()
	paredes.erase(parede)

func mostrar_placar():
	$TentandoEmPLACAR.get_node("PlacarLabel").text = "PLACAR: " + str(placar)
