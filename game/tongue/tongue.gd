# Tongue attack mechanic
extends Area2D

# Constants
const MAX_LENGTH = 100.0
const EXTEND_SPEED = 800.0
const RETRACT_SPEED = 1000.0

# State
var state: String = "retracted"
var current_length: float = 0.0

# Signals
signal extended
signal retracted
signal hit_fly(fly: Node)
signal hit_frog(frog: Node)
signal missed

# References
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var catch_sound = null

func _ready():
	collision.disabled = true
	visible = false
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	
	# Find catch sound
	for child in get_children():
		if child.name == "CatchSound":
			catch_sound = child

func _physics_process(delta: float):
	if state == "extending":
		current_length += EXTEND_SPEED * delta
		update_length()
		
		if current_length >= MAX_LENGTH:
			start_retract()
	
	elif state == "retracting":
		current_length -= RETRACT_SPEED * delta
		update_length()
		
		if current_length <= 0:
			finish_retract()

func extend():
	"""Start extending the tongue"""
	if state == "retracted":
		state = "extending"
		visible = true
		collision.disabled = false
		extended.emit()

func start_retract():
	"""Start retracting the tongue"""
	if state != "retracting":
		state = "retracting"
		collision.disabled = true
		if current_length >= MAX_LENGTH:
			missed.emit()

func finish_retract():
	"""Finish retracting"""
	state = "retracted"
	current_length = 0
	visible = false
	retracted.emit()

func update_length():
	"""Update visual length of tongue"""
	var safe_length = max(0.1, current_length)  # Prevent negative/zero size
	sprite.scale.x = safe_length
	collision.position.x = safe_length / 2
	var shape = collision.shape as RectangleShape2D
	if shape:
		shape.size.x = safe_length

func _on_area_entered(area: Area2D):
	"""Handle collision with flies or frogs"""
	if area.is_in_group("flies"):
		hit_fly.emit(area)
		if catch_sound:
			catch_sound.play()
		start_retract()
	elif area.is_in_group("frogs") and area != get_parent():
		hit_frog.emit(area)
		start_retract()

func _on_body_entered(body: Node2D):
	"""Handle collision with frog bodies"""
	if body.is_in_group("frogs") and body != get_parent():
		hit_frog.emit(body)
		start_retract()
