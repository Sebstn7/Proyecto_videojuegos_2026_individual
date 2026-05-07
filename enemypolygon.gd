extends Polygon2D

func _ready():
	polygon = [
		Vector2(0, 0),
		Vector2(32, 0),
		Vector2(32, 32),
		Vector2(0, 32)
	]
	
	color = Color(1, 0, 0) # rojo para enemigo
