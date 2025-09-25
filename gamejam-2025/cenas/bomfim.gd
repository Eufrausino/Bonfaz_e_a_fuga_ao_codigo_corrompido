extends CharacterBody2D

# === CONFIGURAÇÕES DE FÍSICA ===
const JUMP_VELOCITY = -900.0
@export var gravity = 2000.0 # Usar @export permite ajustar a gravidade no editor do Godot

# === ESTADO DO JOGADOR ===
# É uma boa prática não depender do nome da animação para saber o que o jogador está fazendo.
# Vamos usar o próprio estado do CharacterBody2D (is_on_floor).

# --- MÉTODOS DO GODOT ---

func _ready():
	# Conectamos o sinal de "animação finalizada" a uma função.
	# Isso garante que podemos reagir quando uma animação que NÃO está em loop terminar.
	Engine.max_fps = 60
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	
	# Inicia a primeira animação da sequência.
	$AnimatedSprite2D.play("parada")

# Variáveis adicionais para coyote time
@export var coyote_time = 0.15
var coyote_timer = 0.0

@export var jump_cut_multiplier = 0.9 

func _physics_process(delta):
	# 1. Atualizar coyote timer
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# 2. Aplicar gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# 3. Lógica de Pulo com coyote time
	if Input.is_action_just_pressed("ui_accept") and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("pular") # animação de pulo
		$"pulo".play()
		coyote_timer = 0  # zera o timer após o pulo

	# 4. Jump Hold: cortar o salto se soltar o botão antes de atingir o topo
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier

	# 5. Lógica de animação ao pousar
	if is_on_floor() and $AnimatedSprite2D.animation == "pular":
		$AnimatedSprite2D.play("correndo-2")

	# 6. Mover o personagem
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
