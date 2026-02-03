# Main game loop and scene management
extends Node2D

const FROG_SCENE = preload("res://game/frog/frog.tscn")
const FLY_SCENE = preload("res://game/fly/fly.tscn")
const SCREEN_WIDTH = 1280
const SCREEN_HEIGHT = 720
const SPAWN_MARGIN = 50

var time_elapsed: float = 0.0
var active_flies: Array = []

func _ready():
	GameState.reset_game()
	GameState.game_over.connect(_on_game_over)
	spawn_frog(1, Vector2(200, 650))
	if GameState.game_mode in [GameState.MODE_COOP, GameState.MODE_COMPETITIVE]:
		spawn_frog(2, Vector2(1000, 650))
	for i in range(GameState.max_flies):
		spawn_fly()

func spawn_frog(player_number: int, spawn_pos: Vector2):
	var frog = FROG_SCENE.instantiate()
	frog.player_number = player_number
	frog.position = spawn_pos
	add_child(frog)
	if frog.tongue:
		frog.tongue.hit_fly.connect(_on_tongue_hit_fly.bind(frog))
		frog.tongue.hit_frog.connect(_on_tongue_hit_frog)

func spawn_fly():
	var fly = FLY_SCENE.instantiate()
	fly.position = Vector2(
		randf_range(SPAWN_MARGIN, SCREEN_WIDTH - SPAWN_MARGIN),
		randf_range(SPAWN_MARGIN, SCREEN_HEIGHT - SPAWN_MARGIN)
	)
	add_child(fly)
	active_flies.append(fly)
	fly.caught.connect(_on_fly_caught)
	fly.escaped.connect(_on_fly_escaped.bind(fly))

func _process(delta: float):
	if GameState.game_state == GameState.STATE_PLAYING:
		time_elapsed += delta
		GameState.time_remaining = max(0.0, 60.0 - time_elapsed)
		if GameState.time_remaining <= 10.0 and GameState.time_remaining > 9.9:
			GameState.time_warning.emit(GameState.time_remaining)
		if GameState.time_remaining <= 0.0:
			GameState.end_game()
		while active_flies.size() < GameState.max_flies:
			spawn_fly()

func _on_tongue_hit_fly(fly: Node, catcher: Node):
	if fly and is_instance_valid(fly):
		fly.get_caught(catcher)

func _on_fly_caught(points: int, catcher: Node):
	GameState.add_points(points, catcher.player_number if catcher else 1)

func _on_fly_escaped(fly: Node):
	active_flies.erase(fly)

func _on_tongue_hit_frog(frog: Node):
	if GameState.game_mode == GameState.MODE_COMPETITIVE:
		frog.stun(1.0)

func _on_game_over(final_scores: Dictionary):
	get_tree().change_scene_to_file("res://game/ui/game_over.tscn")
