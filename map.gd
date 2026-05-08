extends Node2D

var grid_size = 32

var map_size = 13

var start_x = 1
var start_y = 1

@onready var wall_scene = preload("res://wall.tscn")

func _ready():
	generate_walls()

func generate_walls():

	for x in range(map_size):
		for y in range(map_size):

			if x == 0 or y == 0 or x == map_size - 1 or y == map_size - 1:

				var wall = wall_scene.instantiate()

				wall.position = Vector2(
					(start_x + x) * grid_size,
					(start_y + y) * grid_size
				)

				add_child(wall)
