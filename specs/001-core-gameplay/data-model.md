# Data Model: Core Gameplay

**Feature**: 001-core-gameplay
**Date**: 2026-02-02

This document describes the game entities and their relationships in terms a beginner can understand.

## Entity Overview

```text
┌─────────────────┐     controls     ┌─────────────────┐
│     Player      │─────────────────▶│      Frog       │
│  (human input)  │                  │  (game object)  │
└─────────────────┘                  └────────┬────────┘
                                              │ has
                                              ▼
                                     ┌─────────────────┐
                                     │     Tongue      │
                                     │   (attack)      │
                                     └────────┬────────┘
                                              │ catches
                                              ▼
                                     ┌─────────────────┐
                                     │      Fly        │
                                     │   (target)      │
                                     └─────────────────┘

┌─────────────────┐
│  Game Session   │ manages all of the above
└─────────────────┘
```

---

## Frog

The player-controlled character.

### Properties

| Property | Type | Description |
|----------|------|-------------|
| position | Vector2 | Where the frog is on screen (x, y) |
| velocity | Vector2 | How fast the frog is moving |
| facing | String | "left" or "right" |
| player_number | int | 1 or 2 (which player controls this frog) |
| state | String | "normal", "jumping", "attacking", or "stunned" |
| score | int | Points this frog has caught (competitive mode only) |

### States

```text
    ┌──────────┐
    │  normal  │◀───────────────────┐
    └────┬─────┘                    │
         │ press jump              land
         ▼                          │
    ┌──────────┐                    │
    │ jumping  │────────────────────┘
    └────┬─────┘
         │ press attack (any state except stunned)
         ▼
    ┌──────────┐
    │attacking │──── tongue retracts ───▶ back to previous state
    └──────────┘

    ┌──────────┐
    │ stunned  │──── timer expires ───▶ normal
    └──────────┘
```

### Behavior

- **Movement**: Left/right arrow or A/D keys move horizontally
- **Jump**: Spacebar or W key makes frog jump; gravity pulls back down
- **Attack**: Attack button shoots tongue forward
- **Stun**: When hit by other frog's tongue (competitive mode), cannot move for 1 second

---

## Tongue

The frog's attack - extends forward to catch flies.

### Properties

| Property | Type | Description |
|----------|------|-------------|
| owner | Frog | Which frog this tongue belongs to |
| state | String | "retracted" or "extended" |
| length | float | How far the tongue has extended (0 to max) |
| max_length | float | Maximum reach (1/4 of screen width) |
| speed | float | How fast the tongue extends/retracts |

### States

```text
    ┌───────────┐
    │ retracted │◀──────────────────────┐
    └─────┬─────┘                       │
          │ attack pressed              │ reached max OR hit something
          ▼                             │
    ┌───────────┐                       │
    │ extending │───────────────────────┤
    └───────────┘                       │
          │                             │
          ▼                             │
    ┌───────────┐                       │
    │retracting │───────────────────────┘
    └───────────┘
```

### Behavior

- **Extend**: When attack pressed, tongue shoots forward in facing direction
- **Collision**: If tongue touches a fly, the fly is caught
- **Combat**: In competitive mode, if tongue touches other frog, that frog is stunned
- **Retract**: Tongue automatically returns to frog after extending

---

## Fly

The target to catch for points.

### Properties

| Property | Type | Description |
|----------|------|-------------|
| position | Vector2 | Where the fly is on screen |
| velocity | Vector2 | Current movement direction and speed |
| points | int | How many points this fly is worth (default: 1) |
| time_alive | float | How long this fly has existed |
| max_time | float | How long before fly escapes |

### Behavior

- **Movement**: Flies move in random, unpredictable patterns
- **Spawning**: New flies appear at random screen positions
- **Escape**: If not caught within time limit, fly leaves screen
- **Caught**: When tongue collides, fly disappears and adds to score

---

## Game Session

Manages one round of gameplay.

### Properties

| Property | Type | Description |
|----------|------|-------------|
| mode | String | "coop" or "competitive" |
| state | String | "menu", "playing", "paused", "game_over" |
| time_remaining | float | Seconds left in round (default: 60) |
| team_score | int | Shared score (co-op mode) |
| player1_score | int | Player 1's score (competitive mode) |
| player2_score | int | Player 2's score (competitive mode) |
| max_flies | int | Maximum flies on screen at once (default: 5) |
| current_flies | Array | List of active fly objects |
| frogs | Array | The two frog objects |

### States

```text
    ┌───────┐
    │ menu  │
    └───┬───┘
        │ start game
        ▼
    ┌─────────┐◀──── unpause
    │ playing │
    └────┬────┘───── pause ────▶ ┌────────┐
         │                       │ paused │
         │ time runs out         └────────┘
         ▼
    ┌───────────┐
    │ game_over │──── restart ───▶ menu or playing
    └───────────┘
```

### Game Modes

**Co-op Mode**:
- Both frogs contribute to team_score
- Players work together against the clock
- Win condition: Beat previous high score

**Competitive Mode**:
- Each frog has separate score
- Players compete for flies
- Frog combat enabled (tongue can stun other frog)
- Win condition: Higher score when time runs out

---

## Player (Input)

Represents a human player's input bindings.

### Properties

| Property | Type | Description |
|----------|------|-------------|
| player_number | int | 1 or 2 |
| input_device | String | "keyboard" or "gamepad" |
| frog | Frog | Which frog this player controls |

### Default Controls

**Player 1 (Keyboard)**:
- Move left: A
- Move right: D
- Jump: W or Space
- Attack: E or Left Shift

**Player 2 (Keyboard)**:
- Move left: Left Arrow
- Move right: Right Arrow
- Jump: Up Arrow
- Attack: Right Shift or / (slash)

**Gamepad (both players)**:
- Move: Left stick or D-pad
- Jump: A button (bottom)
- Attack: X button (left) or Right trigger

---

## Relationships Summary

| Entity | Relationship | Entity |
|--------|--------------|--------|
| Player | controls | Frog |
| Frog | has | Tongue |
| Tongue | catches | Fly |
| Tongue | stuns (competitive) | Frog |
| Game Session | contains | Frog (x2) |
| Game Session | spawns | Fly (many) |
| Game Session | tracks | Score(s) |
