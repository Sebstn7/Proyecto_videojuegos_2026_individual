extends CharacterBody2D

var grid_size = 32
var moving = false
var target_position = Vector2.ZERO
var move_speed = 120

var last_direction = Vector2.RIGHT

@onready var ice_block_scene = preload("res://block.tscn")

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

	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):

		direction = Vector2.RIGHT
		last_direction = direction

	elif Input.is_action_pressed("ui_left"):

		direction = Vector2.LEFT
		last_direction = direction

	elif Input.is_action_pressed("ui_down"):

		direction = Vector2.DOWN
		last_direction = direction

	elif Input.is_action_pressed("ui_up"):

		direction = Vector2.UP
		last_direction = direction

	if direction != Vector2.ZERO:

		var movement = direction * grid_size

		if not test_move(transform, movement):

			target_position += movement
			moving = true

	if Input.is_action_just_pressed("ui_accept"):

		create_ice_block()

func create_ice_block():

	var block_position = global_position + (
		last_direction * grid_size
	)

	var block = ice_block_scene.instantiate()

	block.global_position = block_position

	get_parent().add_child(block)
