extends Node

var virus1 = preload("res://cenas/virus.tscn")
var virus2 = preload("res://cenas/virus_2.tscn")
var tipos_obstaculos := [virus1, virus2]
var obstaculos : Array
var virusHeights := [215, 390]
var ultimoObjeto

var alturaChao : int

const BOMFIM_POS_INICIAL:= Vector2i(520,510)
const CAM_POS_INICIAL:= Vector2i(576,324)

var velocidade_bomfim : float
const VELOCIDDADE_INICIAL : float = 7.0
const MAX_VELOCIDADE: int =  50.0

const POS_CHAO:= Vector2i(2,6)

var velocidade_onda:float
var tam_tela : Vector2i

var game_running : bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tam_tela = get_window().size
	alturaChao = $Chao.get_node("chao1").texture.get_height()
	novo_jogo()

func novo_jogo():
	$bomfim.position = BOMFIM_POS_INICIAL
	$bomfim.velocity = Vector2i(0,0)
	$Camera2D.position =  CAM_POS_INICIAL
	$Chao.position = POS_CHAO
	game_running = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if game_running == true:
		$"Fundo/background_music".play()
		
	velocidade_bomfim = VELOCIDDADE_INICIAL
	
	gerar_obstaculo()
	
	$bomfim.position.x += velocidade_bomfim
	$Camera2D.position.x += velocidade_bomfim
	
	velocidade_onda = velocidade_bomfim - 5
	$Ondas.position.x += velocidade_bomfim
	
	if $Camera2D.position.x - $Chao.position.x > tam_tela.x * 1.5:
		$Chao.position.x += tam_tela.x
	
	for obs in obstaculos:
		if obs.position.x < ($Camera2D.position.x - tam_tela.x):
			removerObstaculo(obs)
	

func gerar_obstaculo():
	var margem_saida_da_tela = 50 

	if obstaculos.is_empty() or ultimoObjeto.position.x < ($Camera2D.position.x - tam_tela.x / 2) - margem_saida_da_tela:
		
		var tipoObstaculo = tipos_obstaculos[randi() % tipos_obstaculos.size()]
		var obstaculo = tipoObstaculo.instantiate()
		
		var obstaculo_x : int = $Camera2D.position.x + (tam_tela.x / 2) + randi_range(100, 400)
		var obstaculo_y : int = virusHeights[randi() % virusHeights.size()]
		
		ultimoObjeto = obstaculo
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
	get_tree().paused = true
	$"bomfim/morte".play()
	game_running = false

func removerObstaculo(obs):
	obs.queue_free()
	obstaculos.erase(obs)
