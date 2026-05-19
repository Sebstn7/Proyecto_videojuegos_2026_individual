extends CharacterBody2D

var grid_size = 32
var moving = false
var target_position = Vector2.ZERO
var move_speed = 120

var last_direction = Vector2.RIGHT

var hold_timer = 0.0
var hold_delay = 0.1

var changing_level = false

@onready var block_scene = preload("res://block.tscn")

func _ready():

	target_position = global_position

func _physics_process(delta):

	# CAMBIAR NIVELES
	if Input.is_action_just_pressed("level1"):

		get_tree().paused = false

		get_tree().change_scene_to_file(
			"res://game.tscn"
		)

	if Input.is_action_just_pressed("level2"):

		get_tree().paused = false

		get_tree().change_scene_to_file(
			"res://game_level2.tscn"
		)

	if Input.is_action_just_pressed("level3"):

		get_tree().paused = false

		get_tree().change_scene_to_file(
			"res://game_level3.tscn"
		)

	if moving:

		global_position = global_position.move_toward(
			target_position,
			move_speed * delta
		)

		if global_position.distance_to(target_position) < 1:

			global_position = target_position
			moving = false

		return

	var input_direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):

		input_direction = Vector2.RIGHT

	elif Input.is_action_pressed("ui_left"):

		input_direction = Vector2.LEFT

	elif Input.is_action_pressed("ui_down"):

		input_direction = Vector2.DOWN

	elif Input.is_action_pressed("ui_up"):

		input_direction = Vector2.UP

	if input_direction != Vector2.ZERO:

		if input_direction != last_direction:

			last_direction = input_direction
			hold_timer = 0
			return

		hold_timer += delta

		if hold_timer >= hold_delay:

			move_player(input_direction)

	else:

		hold_timer = 0

	# CREAR / DESTRUIR BLOQUE
	if Input.is_action_just_pressed("ui_accept"):

		create_block()

	if not changing_level:

		check_goals()

func move_player(direction):

	var movement = direction * grid_size

	if not test_move(transform, movement):

		target_position += movement
		moving = true

func create_block():

	var snapped_position = Vector2(
		round(global_position.x / grid_size) * grid_size,
		round(global_position.y / grid_size) * grid_size
	)

	var block_position = snapped_position + (
		last_direction * grid_size
	)

	for child in get_parent().get_children():

		if child.is_in_group("blocks"):

			var child_snapped = Vector2(
				round(child.global_position.x / grid_size) * grid_size,
				round(child.global_position.y / grid_size) * grid_size
			)

			if child_snapped == block_position:

				child.queue_free()
				return

	var block = block_scene.instantiate()

	block.global_position = block_position

	get_parent().add_child(block)

func check_goals():

	if not is_inside_tree():
		return

	var tree = get_tree()

	if tree == null:
		return

	var goals = tree.get_nodes_in_group(
		"goals"
	)

	if goals.size() == 0:

		changing_level = true

		tree.paused = false

		var current_scene = tree.current_scene.scene_file_path

		if current_scene == "res://game.tscn":

			tree.change_scene_to_file(
				"res://game_level2.tscn"
			)

		elif current_scene == "res://game_level2.tscn":

			tree.change_scene_to_file(
				"res://game_level3.tscn"
			)

		elif current_scene == "res://game_level3.tscn":

			var win_label = tree.current_scene.get_node(
				"UI2/WinLabel"
			)

			win_label.visible = true

			tree.paused = true
