# Input Actions

**Feature**: 001-core-gameplay
**Date**: 2026-02-02

This document defines the input actions for BattleFrog. In Godot, you define "actions" (like "player1_jump") and then map keys/buttons to them.

## Why Use Input Actions?

Instead of checking for specific keys:
```gdscript
# Bad - hard to change, doesn't support gamepad
if Input.is_key_pressed(KEY_SPACE):
    jump()
```

We check for actions:
```gdscript
# Good - works with keyboard AND gamepad
if Input.is_action_pressed("player1_jump"):
    jump()
```

---

## Player 1 Actions

| Action Name | Purpose | Default Keys | Default Gamepad |
|-------------|---------|--------------|-----------------|
| `player1_left` | Move frog left | A | Left stick left, D-pad left |
| `player1_right` | Move frog right | D | Left stick right, D-pad right |
| `player1_jump` | Make frog jump | W, Space | A button (bottom) |
| `player1_attack` | Shoot tongue | E, Left Shift | X button (left), Right trigger |
| `player1_pause` | Pause game | Escape | Start button |

---

## Player 2 Actions

| Action Name | Purpose | Default Keys | Default Gamepad |
|-------------|---------|--------------|-----------------|
| `player2_left` | Move frog left | Left Arrow | Left stick left, D-pad left |
| `player2_right` | Move frog right | Right Arrow | Left stick right, D-pad right |
| `player2_jump` | Make frog jump | Up Arrow | A button (bottom) |
| `player2_attack` | Shoot tongue | Right Shift, / | X button (left), Right trigger |

---

## Menu Actions

| Action Name | Purpose | Default Keys | Default Gamepad |
|-------------|---------|--------------|-----------------|
| `ui_up` | Navigate menu up | W, Up Arrow | D-pad up, Left stick up |
| `ui_down` | Navigate menu down | S, Down Arrow | D-pad down, Left stick down |
| `ui_accept` | Select menu item | Enter, Space | A button |
| `ui_cancel` | Go back / Cancel | Escape | B button |

---

## How to Set Up in Godot

1. Open Project → Project Settings → Input Map
2. Add new action (type name, press Add)
3. Click + next to action
4. Press the key or button you want to add
5. Repeat for all keys/buttons for that action

### Example Screenshot Description

```text
Input Map tab in Project Settings:
┌─────────────────────────────────────────────┐
│ Action                 │ Keys/Buttons       │
├─────────────────────────────────────────────┤
│ player1_left          │ A, Joypad Axis 0-  │
│ player1_right         │ D, Joypad Axis 0+  │
│ player1_jump          │ W, Space, Joypad 0 │
│ player1_attack        │ E, Shift, Joypad 2 │
│ ...                   │                     │
└─────────────────────────────────────────────┘
```

---

## Using Actions in Code

### Check if button is held down

```gdscript
func _physics_process(delta):
    # Movement (continuous while held)
    if Input.is_action_pressed("player1_left"):
        velocity.x = -move_speed
    elif Input.is_action_pressed("player1_right"):
        velocity.x = move_speed
    else:
        velocity.x = 0
```

### Check if button was just pressed

```gdscript
func _physics_process(delta):
    # Jump (only on initial press, not while held)
    if Input.is_action_just_pressed("player1_jump"):
        if is_on_floor():
            velocity.y = -jump_force
```

### Check if button was just released

```gdscript
func _physics_process(delta):
    # Could be used for variable jump height
    if Input.is_action_just_released("player1_jump"):
        if velocity.y < 0:
            velocity.y *= 0.5  # Cut jump short
```

---

## Supporting Multiple Controllers

Godot automatically assigns gamepad numbers:
- First gamepad connected = Device 0
- Second gamepad connected = Device 1

In Project Settings, when adding gamepad inputs:
- Player 1 actions → Device 0
- Player 2 actions → Device 1

### Handling Controller Connect/Disconnect

```gdscript
# In input_manager.gd (autoload)
func _ready():
    Input.joy_connection_changed.connect(_on_joy_connection_changed)

func _on_joy_connection_changed(device_id, connected):
    if connected:
        print("Controller ", device_id, " connected!")
    else:
        print("Controller ", device_id, " disconnected!")
        # Pause game and show reconnection message
        get_tree().paused = true
```

---

## Input Priority

When a player has both keyboard and gamepad:
- Both work simultaneously
- No conflict - pressing keyboard A and pushing stick left both trigger `player1_left`
- This is a feature, not a bug! Lets players use what feels comfortable.

---

## Testing Input

Simple test scene to verify inputs are working:

```gdscript
# test_input.gd
extends Node2D

func _process(delta):
    # Player 1
    if Input.is_action_pressed("player1_left"):
        $Player1Label.text = "P1: LEFT"
    elif Input.is_action_pressed("player1_right"):
        $Player1Label.text = "P1: RIGHT"
    else:
        $Player1Label.text = "P1: ---"

    if Input.is_action_just_pressed("player1_jump"):
        $Player1Label.text += " JUMP!"

    if Input.is_action_just_pressed("player1_attack"):
        $Player1Label.text += " ATTACK!"

    # Repeat for Player 2...
```
