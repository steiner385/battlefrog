# Frog character controller
extends CharacterBody2D

const MOVE_SPEED = 200.0
const JUMP_FORCE = -400.0
const GRAVITY = 980.0
const SCREEN_WIDTH = 1280
const SCREEN_HEIGHT = 720

var player_number: int = 1
var facing: String = "right"
var state: String = "normal"
var stun_timer: float = 0.0

signal jumped
signal attacked
signal stunned(duration: float)
signal recovered
signal facing_changed(direction: String)

@onready var tongue = null
@onready var jump_sound = null
@onready var stun_sound = null

func _ready():
	add_to_group("frogs")
	for child in get_children():
		if child.name == "Tongue": tongue = child
		elif child.name == "JumpSound": jump_sound = child
		elif child.name == "StunSound": stun_sound = child

func _physics_process(delta: float):
	if state == "stunned":
		stun_timer -= delta
		if stun_timer <= 0:
			state = "normal"
			recovered.emit()
			modulate = Color(1, 1, 1, 1)
		return
	
	if not is_on_floor(): velocity.y += GRAVITY * delta
	
	var input_prefix = "player" + str(player_number) + "_"
	if Input.is_action_pressed(input_prefix + "left"):
		velocity.x = -MOVE_SPEED
		set_facing("left")
	elif Input.is_action_pressed(input_prefix + "right"):
		velocity.x = MOVE_SPEED
		set_facing("right")
	else:
		velocity.x = 0
	
	if Input.is_action_just_pressed(input_prefix + "jump") and is_on_floor():
		velocity.y = JUMP_FORCE
		jumped.emit()
		if jump_sound: jump_sound.play()
	
	if Input.is_action_just_pressed(input_prefix + "attack") and tongue:
		attacked.emit()
		tongue.extend()
	
	move_and_slide()
	position.x = clamp(position.x, 16, SCREEN_WIDTH - 16)
	position.y = clamp(position.y, 16, SCREEN_HEIGHT - 16)

func set_facing(direction: String):
	if facing != direction:
		facing = direction
		facing_changed.emit(direction)
		scale.x = -1 if direction == "left" else 1

func stun(duration: float):
	state = "stunned"
	stun_timer = duration
	stunned.emit(duration)
	modulate = Color(0.5, 0.5, 0.5, 1)
	if stun_sound: stun_sound.play()
