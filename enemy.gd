extends CharacterBody2D

var speed = 100
var direction = Vector2.RIGHT

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()
	
	if is_on_wall():
		direction = -direction
