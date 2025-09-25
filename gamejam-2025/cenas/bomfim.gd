extends CharacterBody2D

# === CONFIGURAÇÕES DE FÍSICA ===
const JUMP_VELOCITY = -400.0
@export var gravity = 900.0 # Usar @export permite ajustar a gravidade no editor do Godot

# === ESTADO DO JOGADOR ===
# É uma boa prática não depender do nome da animação para saber o que o jogador está fazendo.
# Vamos usar o próprio estado do CharacterBody2D (is_on_floor).

# --- MÉTODOS DO GODOT ---

func _ready():
	# Conectamos o sinal de "animação finalizada" a uma função.
	# Isso garante que podemos reagir quando uma animação que NÃO está em loop terminar.
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	
	# Inicia a primeira animação da sequência.
	$AnimatedSprite2D.play("parada")

func _physics_process(delta):
	# 1. Aplicar gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Lógica de Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("pular") # A animação de pulo tem prioridade
		$"pulo".play()

	# 3. Lógica de animação ao pousar
	# Se estamos no chão e a animação atual é "pular", significa que acabamos de pousar.
	# Então, voltamos para a animação de corrida principal.
	if is_on_floor() and $AnimatedSprite2D.animation == "pular":
		$AnimatedSprite2D.play("correndo-2")

	# 4. Mover o personagem
	move_and_slide()


# --- MANIPULAÇÃO DE SINAIS ---

# Esta função é chamada AUTOMATICAMENTE quando uma animação termina.
# ATENÇÃO: Só funciona para animações que NÃO estão com o "Loop" ativado.
func _on_animation_finished():
	# Pegamos o nome da animação que acabou de terminar
	var finished_animation = $AnimatedSprite2D.animation

	# Se a animação "parada" terminou, começa a "correndo"
	if finished_animation == "parada":
		$AnimatedSprite2D.play("correndo")
	
	# Se a animação "correndo" (que é a transição) terminou,
	# começa a "correndo-2", que será a nossa corrida principal em loop.
	elif finished_animation == "correndo":
		$AnimatedSprite2D.play("correndo-2")
