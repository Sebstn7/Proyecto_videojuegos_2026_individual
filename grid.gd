extends Node2D

var grid_size = 32

var columns = 15
var rows = 15

var width = columns * grid_size
var height = rows * grid_size

func _draw():

	# Líneas verticales
	for x in range(columns + 1):
		draw_line(
			Vector2(x * grid_size, 0),
			Vector2(x * grid_size, height),
			Color(0.5, 0.5, 0.5),
			1
		)

	# Líneas horizontales
	for y in range(rows + 1):
		draw_line(
			Vector2(0, y * grid_size),
			Vector2(width, y * grid_size),
			Color(0.5, 0.5, 0.5),
			1
		)
