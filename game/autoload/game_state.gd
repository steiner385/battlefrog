# Game state management - accessible from anywhere as GameState
extends Node

# Game modes
const MODE_COOP = "coop"
const MODE_COMPETITIVE = "competitive"

# Game states
const STATE_MENU = "menu"
const STATE_PLAYING = "playing"
const STATE_PAUSED = "paused"
const STATE_GAME_OVER = "game_over"

# Properties
var game_mode: String = MODE_COOP
var game_state: String = STATE_MENU
var time_remaining: float = 60.0
var team_score: int = 0
var player1_score: int = 0
var player2_score: int = 0
var max_flies: int = 5

# Signals
signal score_changed(player: int, new_score: int)
signal game_over(final_scores: Dictionary)
signal time_warning(time_remaining: float)
signal game_started(mode: String)
signal game_paused
signal game_resumed
signal fly_spawned(fly: Node)

func _ready():
	print("GameState autoload initialized")

func reset_game():
	"""Reset scores and timer for a new game"""
	team_score = 0
	player1_score = 0
	player2_score = 0
	time_remaining = 60.0
	game_state = STATE_PLAYING
	game_started.emit(game_mode)

func get_score(player_number: int) -> int:
	"""Get score for a specific player (1 or 2) or team (0)"""
	if game_mode == MODE_COOP:
		return team_score
	elif player_number == 1:
		return player1_score
	else:
		return player2_score

func add_points(points: int, catcher_player: int = 0):
	"""Add points to score"""
	if game_mode == MODE_COOP:
		team_score += points
		score_changed.emit(0, team_score)
	else:
		if catcher_player == 1:
			player1_score += points
		else:
			player2_score += points
		score_changed.emit(catcher_player, get_score(catcher_player))

func pause_game():
	"""Pause the game"""
	if game_state == STATE_PLAYING:
		game_state = STATE_PAUSED
		game_paused.emit()
		get_tree().paused = true

func resume_game():
	"""Resume the game"""
	if game_state == STATE_PAUSED:
		game_state = STATE_PLAYING
		game_resumed.emit()
		get_tree().paused = false

func end_game():
	"""End the game"""
	game_state = STATE_GAME_OVER
	var final_scores = {
		"team_score": team_score,
		"player1_score": player1_score,
		"player2_score": player2_score,
		"mode": game_mode
	}
	game_over.emit(final_scores)
