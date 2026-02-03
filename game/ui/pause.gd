# Pause menu overlay
extends CanvasLayer

func _ready():
	visible = false

func _process(_delta: float):
	"""Handle pause input"""
	if Input.is_action_just_pressed("player1_pause"):
		if visible:
			resume()
		else:
			pause()

func pause():
	"""Pause the game"""
	visible = true
	GameState.pause_game()

func resume():
	"""Resume the game"""
	visible = false
	GameState.resume_game()

func _on_resume_pressed():
	"""Resume button pressed"""
	resume()

func _on_menu_pressed():
	"""Return to main menu"""
	GameState.resume_game()
	get_tree().change_scene_to_file("res://game/ui/menu.tscn")
