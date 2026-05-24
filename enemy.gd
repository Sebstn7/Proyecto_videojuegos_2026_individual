extends CharacterBody2D

var grid_size = 32
var move_speed = 60

var moving = false
var target_position = Vector2.ZERO

var direction = Vector2.RIGHT

static var reserved_cells = []

@onready var player = get_node("/root/Game/Player")

@export var destroy_blocks = false
@export var yellow_enemy = false

func _ready():

	target_position = global_position
	if yellow_enemy:

		$Polygon2D.color = Color.YELLOW

func _physics_process(delta):

	if destroy_blocks:

		destroy_touching_blocks()

	if moving:

		global_position = global_position.move_toward(
			target_position,
			move_speed * delta
		)

		if global_position.distance_to(target_position) < 1:
			global_position = target_position
			reserved_cells.erase(target_position)

			moving = false

		return

	change_direction()

	var movement = direction * grid_size

	if can_move(movement):

		var next_position = target_position + movement
		reserved_cells.append(next_position)
		target_position = next_position

		moving = true

	else:

		random_direction()

	if global_position.distance_to(player.global_position) < 10:

		var game_over_label = get_tree().current_scene.get_node(
	"UI/GameOverLabel"
		)

		game_over_label.visible = true

		get_tree().paused = true

func can_move(movement):

	var next_position = target_position + movement

	var player_snapped = Vector2(
		round(player.global_position.x / grid_size) * grid_size,
		round(player.global_position.y / grid_size) * grid_size
	)

	if next_position == player_snapped:

		return true

	if next_position in reserved_cells:

		return false

	if test_move(transform, movement):

		return false

	return true

func destroy_touching_blocks():

	for child in get_parent().get_children():

		if child.is_in_group("blocks"):

			var dx = abs(
				child.global_position.x - global_position.x
			)

			var dy = abs(
				child.global_position.y - global_position.y
			)

			if dx <= 40 and dy <= 40:

				child.queue_free()

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
