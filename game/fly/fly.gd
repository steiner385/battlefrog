# Fly enemy that moves randomly
extends Area2D

# Constants
const MOVE_SPEED = 100.0
const ESCAPE_TIME = 10.0
const DIRECTION_CHANGE_TIME = 0.5

# Properties
var points: int = 1
var time_alive: float = 0.0
var max_time: float = ESCAPE_TIME
var velocity: Vector2 = Vector2.ZERO
var direction_timer: float = 0.0

# Signals
signal caught(points: int, catcher: Node)
signal escaped
signal spawned

func _ready():
	add_to_group("flies")
	randomize_direction()
	spawned.emit()
	print("Fly spawned at", position)

func _physics_process(delta: float):
	time_alive += delta
	direction_timer -= delta
	
	# Change direction randomly
	if direction_timer <= 0:
		randomize_direction()
	
	# Move
	position += velocity * delta
	
	# Check escape
	if time_alive >= max_time:
		escape()

func randomize_direction():
	"""Pick a random movement direction"""
	var angle = randf() * TAU
	velocity = Vector2(cos(angle), sin(angle)) * MOVE_SPEED
	direction_timer = DIRECTION_CHANGE_TIME

func escape():
	"""Fly escapes (timeout)"""
	escaped.emit()
	queue_free()

func get_caught(catcher: Node):
	"""Called when caught by tongue"""
	caught.emit(points, catcher)
	queue_free()
