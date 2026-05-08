extends CharacterBody2D

var grid_size = 32
var move_speed = 70

var moving = false
var target_position = Vector2.ZERO

var direction = Vector2.RIGHT

@onready var player = get_node("/root/Game/Player")

func _ready():
	target_position = global_position

func _physics_process(delta):

	if moving:

		global_position = global_position.move_toward(
			target_position,
			move_speed * delta
		)

		if global_position.distance_to(target_position) < 1:

			global_position = target_position
			moving = false

		return

	change_direction()

	var movement = direction * grid_size

	if can_move(movement):

		target_position += movement
		moving = true

	if global_position.distance_to(player.global_position) < 10:

		print("GAME OVER")

func can_move(movement):

	var collision = move_and_collide(movement, true)

	if collision == null:
		return true

	if collision.get_collider() == player:
		return true

	return false

func change_direction():

	var distance_to_player = global_position.distance_to(
		player.global_position
	)

	if distance_to_player < 160:

		chase_player()

	else:

		random_direction()

func chase_player():

	var directions = []

	var dx = player.global_position.x - global_position.x
	var dy = player.global_position.y - global_position.y

	if abs(dx) > abs(dy):

		if dx > 0:
			directions.append(Vector2.RIGHT)
		else:
			directions.append(Vector2.LEFT)

		if dy > 0:
			directions.append(Vector2.DOWN)
		else:
			directions.append(Vector2.UP)

	else:

		if dy > 0:
			directions.append(Vector2.DOWN)
		else:
			directions.append(Vector2.UP)

		if dx > 0:
			directions.append(Vector2.RIGHT)
		else:
			directions.append(Vector2.LEFT)

	for dir in directions:

		if can_move(dir * grid_size):

			direction = dir
			return

	random_direction()

func random_direction():

	var directions = [
		Vector2.RIGHT,
		Vector2.LEFT,
		Vector2.UP,
		Vector2.DOWN
	]

	directions.shuffle()

	for dir in directions:

		if can_move(dir * grid_size):

			direction = dir
			return
