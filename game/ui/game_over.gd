# Game over screen
extends Control

@onready var winner_label = $VBoxContainer/WinnerLabel
@onready var scores_label = $VBoxContainer/ScoresLabel

func _ready():
	"""Display game over information"""
	display_results()

func display_results():
	"""Show winner and scores"""
	if GameState.game_mode == GameState.MODE_COOP:
		winner_label.text = "Final Score"
		scores_label.text = "Team: %d" % GameState.team_score
	else:
		# Competitive mode
		var p1_score = GameState.player1_score
		var p2_score = GameState.player2_score
		scores_label.text = "P1: %d  P2: %d" % [p1_score, p2_score]
		
		if p1_score > p2_score:
			winner_label.text = "Player 1 Wins!"
		elif p2_score > p1_score:
			winner_label.text = "Player 2 Wins!"
		else:
			winner_label.text = "It's a Tie!"

func _on_play_again_pressed():
	"""Restart the game with same mode"""
	get_tree().change_scene_to_file("res://game/main.tscn")

func _on_menu_pressed():
	"""Return to main menu"""
	get_tree().change_scene_to_file("res://game/ui/menu.tscn")
