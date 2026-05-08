extends CharacterBody2D

var grid_size = 32
var move_speed = 90

var moving = false
var target_position = Vector2.ZERO

var direction = Vector2.RIGHT

func _ready():

	target_position = global_position

func _physics_process(delta):

	# Movimiento suave
	if moving:

		global_position = global_position.move_toward(
			target_position,
			move_speed * delta
		)

		if global_position.distance_to(target_position) < 1:

			global_position = target_position
			moving = false

		return

	# Intentar avanzar
	var movement = direction * grid_size

	# Si hay muro → cambiar dirección
	if test_move(transform, movement):

		change_direction()

	else:

		target_position += movement
		moving = true

func change_direction():

	var directions = [
		Vector2.RIGHT,
		Vector2.LEFT,
		Vector2.UP,
		Vector2.DOWN
	]

	directions.shuffle()

	for dir in directions:

		if not test_move(transform, dir * grid_size):

			direction = dir
			return
