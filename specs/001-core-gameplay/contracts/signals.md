# Game Signals (Events)

**Feature**: 001-core-gameplay
**Date**: 2026-02-02

In Godot, game objects communicate using **signals** (events). This document defines the signals each object emits and listens to.

## What is a Signal?

A signal is like shouting "something happened!" Other parts of the game can listen and respond. For example, when a fly is caught, the Fly shouts "I was caught!" and the ScoreManager hears it and adds points.

---

## Frog Signals

### Emits (sends out)

| Signal | When | Data Sent |
|--------|------|-----------|
| `jumped` | Player pressed jump | none |
| `landed` | Frog touched ground | none |
| `attacked` | Player pressed attack | none |
| `stunned` | Frog was hit by tongue | `stun_duration: float` |
| `recovered` | Stun ended | none |
| `facing_changed` | Frog turned around | `direction: String` ("left" or "right") |

### Listens to (responds to)

| Signal | From | Response |
|--------|------|----------|
| `tongue_hit_frog` | Tongue | Enter stunned state |

### Example (GDScript)

```gdscript
# In frog.gd
signal jumped
signal stunned(duration)

func _on_jump_pressed():
    jumped.emit()
    velocity.y = -jump_force
```

---

## Tongue Signals

### Emits

| Signal | When | Data Sent |
|--------|------|-----------|
| `extended` | Tongue started shooting out | none |
| `retracted` | Tongue finished returning | none |
| `hit_fly` | Tongue touched a fly | `fly: Fly` |
| `hit_frog` | Tongue touched other frog | `frog: Frog` |
| `missed` | Tongue reached max length, hit nothing | none |

### Listens to

| Signal | From | Response |
|--------|------|----------|
| `attacked` | Frog (owner) | Start extending |

### Example

```gdscript
# In tongue.gd
signal hit_fly(fly)
signal hit_frog(frog)

func _on_area_entered(area):
    if area.is_in_group("flies"):
        hit_fly.emit(area)
    elif area.is_in_group("frogs") and area != owner:
        hit_frog.emit(area)
```

---

## Fly Signals

### Emits

| Signal | When | Data Sent |
|--------|------|-----------|
| `caught` | Fly was hit by tongue | `points: int`, `catcher: Frog` |
| `escaped` | Fly left screen (time ran out) | none |
| `spawned` | Fly appeared on screen | none |

### Listens to

| Signal | From | Response |
|--------|------|----------|
| `hit_fly` | Tongue | Emit `caught`, then disappear |

### Example

```gdscript
# In fly.gd
signal caught(points, catcher)
signal escaped

func _on_caught_by(catcher_frog):
    caught.emit(points, catcher_frog)
    queue_free()  # Remove from game
```

---

## Game Session Signals

### Emits

| Signal | When | Data Sent |
|--------|------|-----------|
| `game_started` | Game begins | `mode: String` |
| `game_paused` | Player paused | none |
| `game_resumed` | Player unpaused | none |
| `game_over` | Time ran out | `final_scores: Dictionary` |
| `score_changed` | Any score updated | `player: int`, `new_score: int` |
| `time_warning` | 10 seconds left | `time_remaining: float` |
| `fly_spawned` | New fly appeared | `fly: Fly` |

### Listens to

| Signal | From | Response |
|--------|------|----------|
| `caught` | Fly | Update score |
| `escaped` | Fly | Remove from tracking |

### Example

```gdscript
# In game_state.gd (autoload)
signal score_changed(player, new_score)
signal game_over(final_scores)

func _on_fly_caught(points, catcher):
    if game_mode == "coop":
        team_score += points
        score_changed.emit(0, team_score)  # 0 = team
    else:
        var player = catcher.player_number
        if player == 1:
            player1_score += points
        else:
            player2_score += points
        score_changed.emit(player, get_score(player))
```

---

## UI Signals

### HUD Listens to

| Signal | From | Response |
|--------|------|----------|
| `score_changed` | Game Session | Update score display |
| `time_warning` | Game Session | Flash timer red |
| `stunned` | Frog | Show stun indicator for player |

### Menu Emits

| Signal | When | Data Sent |
|--------|------|-----------|
| `mode_selected` | Player chose game mode | `mode: String` |
| `start_pressed` | Player pressed start | `player_count: int` |

---

## Signal Flow Example: Catching a Fly

```text
1. Player presses attack button
      │
      ▼
2. Frog emits "attacked" signal
      │
      ▼
3. Tongue (listening) starts extending
      │
      ▼
4. Tongue collides with Fly
      │
      ▼
5. Tongue emits "hit_fly" signal with the Fly
      │
      ▼
6. Fly (listening) emits "caught" signal with points and catcher
      │
      ▼
7. Game Session (listening) updates score
      │
      ▼
8. Game Session emits "score_changed"
      │
      ▼
9. HUD (listening) updates score display
      │
      ▼
10. Fly removes itself from game
```

---

## Connecting Signals in Godot

In Godot, you connect signals in two ways:

**1. In the Editor** (visual, click-based):
- Select node → Node tab → Signals → double-click → choose receiving method

**2. In Code** (for dynamic connections):
```gdscript
# Connect fly's "caught" signal to game_state's "_on_fly_caught" method
fly.caught.connect(game_state._on_fly_caught)
```

---

## Why Signals Matter

Signals keep code **simple and separate**:

- Frog doesn't need to know about scoring
- Fly doesn't need to know about the HUD
- Each piece only does its own job
- Easy to test each part alone

This follows the constitution's Learning-Friendly principle: each file focuses on one thing.
