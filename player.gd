extends CharacterBody2D

var grid_size = 32
var moving = false
var target_position = Vector2.ZERO
var move_speed = 120

func _ready():
	target_position = global_position

func _physics_process(delta):

	# Movimiento suave
	if moving:

		global_position = global_position.move_toward(
			target_position,
			move_speed * delta
		)

		# Llegó a la celda
		if global_position.distance_to(target_position) < 1:

			global_position = target_position
			moving = false

		return

	# Dirección
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT

	elif Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT

	elif Input.is_action_pressed("ui_down"):
		direction = Vector2.DOWN

	elif Input.is_action_pressed("ui_up"):
		direction = Vector2.UP

	# Intentar mover
	if direction != Vector2.ZERO:

		var movement = direction * grid_size

		# test_move verifica colisión ANTES
		if not test_move(transform, movement):

			target_position += movement
			moving = true
