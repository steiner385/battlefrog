# Main menu screen
extends Control

@onready var menu_sound = null

func _ready():
	print("Menu ready")
	# Find menu sound
	for child in get_children():
		if child.name == "MenuSound":
			menu_sound = child

func _on_coop_pressed():
	"""Start co-op mode"""
	if menu_sound:
		menu_sound.play()
	GameState.game_mode = GameState.MODE_COOP
	start_game()

func _on_competitive_pressed():
	"""Start competitive mode"""
	if menu_sound:
		menu_sound.play()
	GameState.game_mode = GameState.MODE_COMPETITIVE
	start_game()

func start_game():
	"""Transition to main game scene"""
	get_tree().change_scene_to_file("res://game/main.tscn")
