extends Control

func _ready():

	$CenterContainer/VBoxContainer/PlayButton.pressed.connect(
		start_game
	)

	$CenterContainer/VBoxContainer/ExitButton.pressed.connect(
		exit_game
	)

func start_game():

	get_tree().change_scene_to_file(
		"res://game.tscn"
	)

func exit_game():

	get_tree().quit()
