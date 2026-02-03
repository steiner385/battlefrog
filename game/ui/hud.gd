# HUD display for score and timer
extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var timer_label = $TimerLabel

func _ready():
	"""Connect to GameState signals"""
	GameState.score_changed.connect(_on_score_changed)
	update_score(0)

func _process(_delta: float):
	"""Update timer display"""
	update_timer()

func update_score(player: int):
	"""Update score display"""
	var score = 0
	if GameState.game_mode == GameState.MODE_COOP:
		score = GameState.team_score
		score_label.text = "Team Score: %d" % score
	else:
		score_label.text = "P1: %d  P2: %d" % [GameState.player1_score, GameState.player2_score]

func update_timer():
	"""Update timer display"""
	var time = int(GameState.time_remaining)
	timer_label.text = "Time: %d" % time
	
	# Flash red when low
	if time <= 10:
		timer_label.modulate = Color(1, 0, 0, 1)
	else:
		timer_label.modulate = Color(1, 1, 1, 1)

func _on_score_changed(player: int, new_score: int):
	"""Handle score change signal"""
	update_score(player)
