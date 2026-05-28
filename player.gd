extends CharacterBody2D

var grid_size = 32
var moving = false
var target_position = Vector2.ZERO
var move_speed = 120

var last_direction = Vector2.RIGHT

var hold_timer = 0.0
var hold_delay = 0.1

var changing_level = false

var goals_label = null
var timer_label = null
var fade_rect = null

var time_left = 60.0

@onready var block_scene = preload("res://block.tscn")

func _ready():

	target_position = global_position

func _physics_process(delta):

	if Input.is_action_just_pressed("restart"):

		get_tree().paused = false

		get_tree().reload_current_scene()

	update_goals_label()

	update_timer(delta)

	if not changing_level:

		check_goals()

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
				round(child.global_position.y /grid_size) * grid_size
			)

			if child_snapped == block_position:

				child.queue_free()
				return

	var block = block_scene.instantiate()

	block.global_position = block_position

	get_parent().add_child(block)

	shake_camera()

func update_goals_label():

	if not is_inside_tree():
		return

	var tree = get_tree()

	if tree == null:
		return

	if not tree.current_scene.has_node(
		"UI/GoalsLabel"
	):
		return

	goals_label = tree.current_scene.get_node(
		"UI/GoalsLabel"
	)

	var remaining = tree.get_nodes_in_group(
		"goals"
	).size()

	var collected = 3 - remaining

	goals_label.text = (
		str(collected) +
		" / 3"
	)

func update_timer(delta):

	if not is_inside_tree():
		return

	var tree = get_tree()

	if tree == null:
		return

	if not tree.current_scene.has_node(
		"UI/TimerLabel"
	):
		return

	timer_label = tree.current_scene.get_node(
		"UI/TimerLabel"
	)

	time_left -= delta

	if time_left < 0:

		time_left = 0

	timer_label.text = (
		"Time: " +
		str(int(time_left))
	)

	if time_left <= 0:

		if tree.current_scene.has_node(
			"UI/GameOverLabel"
		):

			var game_over_label = tree.current_scene.get_node(
				"UI/GameOverLabel"
			)

			game_over_label.visible = true

		await get_tree().create_timer(2.0).timeout

		tree.paused = false

		tree.change_scene_to_file(
			"res://main_menu.tscn"
		)

func check_goals():

	if changing_level:
		return

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

		if tree.current_scene.has_node(
			"UI/FadeRect"
		):

			fade_rect = tree.current_scene.get_node(
				"UI/FadeRect"
			)

			fade_rect.visible = true

			fade_rect.modulate.a = 0

			for i in range(20):

				fade_rect.modulate.a += 0.05

				await get_tree().create_timer(0.03).timeout

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

			if tree.current_scene.has_node(
				"UI2/WinLabel"
			):

				var win_label = tree.current_scene.get_node(
					"UI2/WinLabel"
				)

				win_label.visible = true

				await get_tree().create_timer(3.0).timeout

				tree.paused = false

				tree.change_scene_to_file(
					"res://main_menu.tscn"
				)

func shake_camera():

	var camera = get_node_or_null("Camera2D")

	if camera == null:
		return

	camera.position_smoothing_enabled = false

	for i in range(6):

		camera.offset = Vector2(
			randf_range(-3, 3),
			randf_range(-3, 3)
		)

		await get_tree().create_timer(0.02).timeout

	camera.offset = Vector2.ZERO

	camera.position_smoothing_enabled = true
