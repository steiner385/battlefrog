# Quickstart Guide: BattleFrog

**Feature**: 001-core-gameplay
**Date**: 2026-02-02

This guide helps you set up and run BattleFrog for the first time.

## Prerequisites

Before you start, you need to install Godot:

1. Go to [godotengine.org/download](https://godotengine.org/download)
2. Download **Godot 4.x** (Standard version, not .NET)
3. Extract the zip file
4. Run `Godot_v4.x.x-stable_win64.exe`

No installation needed - Godot runs directly from the extracted folder!

---

## Opening the Project

1. Open Godot
2. Click "Import" in the Project Manager
3. Navigate to the `battlefrog` folder
4. Select `project.godot`
5. Click "Import & Edit"

---

## Project Structure Overview

```text
battlefrog/
├── project.godot      ← Godot project file (double-click to open)
├── game/              ← All game code and scenes
│   ├── main.tscn      ← Main game scene
│   ├── frog/          ← Frog character files
│   ├── fly/           ← Fly enemy files
│   └── ui/            ← Menu and HUD files
├── assets/            ← Images and sounds
└── specs/             ← Design documents (you are here!)
```

---

## Running the Game

### From Godot Editor

1. Press **F5** or click the Play button (▶) in the top right
2. The game will open in a new window
3. Press **Escape** or close the window to stop

### First-Time Setup

If you see "No main scene defined":
1. Go to Project → Project Settings → Application → Run
2. Set "Main Scene" to `game/main.tscn`
3. Press F5 again

---

## Default Controls

### Player 1 (Left Side)

| Action | Key |
|--------|-----|
| Move Left | A |
| Move Right | D |
| Jump | W or Space |
| Attack (tongue) | E |

### Player 2 (Right Side)

| Action | Key |
|--------|-----|
| Move Left | ← (Left Arrow) |
| Move Right | → (Right Arrow) |
| Jump | ↑ (Up Arrow) |
| Attack (tongue) | / (Slash) |

### Menu

| Action | Key |
|--------|-----|
| Navigate | Arrow keys or WASD |
| Select | Enter or Space |
| Pause | Escape |

### Gamepad

Both players can use Xbox/PlayStation controllers:
- Left stick or D-pad to move
- A/X button (bottom) to jump
- X/Square button (left) to attack

---

## Game Modes

### Co-op Mode
- Work together with a friend
- Both frogs share one score
- Catch as many flies as possible before time runs out!

### Competitive Mode
- Compete against your friend
- Each frog has their own score
- You can stun the other frog with your tongue!
- Player with more points wins

---

## How to Play

1. **Start the game** - Select your game mode from the menu
2. **Move your frog** - Use left/right to walk, jump to reach higher flies
3. **Catch flies** - Press attack when a fly is in front of you
4. **Score points** - Each fly is worth 1 point
5. **Watch the timer** - You have 60 seconds per round

### Tips

- Time your tongue! It takes a moment to extend and retract
- In competitive mode, stunning your opponent gives you time to catch flies
- Flies escape if you don't catch them quickly
- Jump to reach flies that are higher up

---

## Troubleshooting

### "Project failed to open"
- Make sure you downloaded Godot 4.x (not 3.x)
- Check that project.godot exists in the folder

### Game won't start (F5 does nothing)
- Set the main scene: Project → Project Settings → Run → Main Scene
- Select `game/main.tscn`

### Controls don't work
- Check Project → Project Settings → Input Map
- Make sure actions like `player1_left` exist

### Gamepad not detected
- Plug in the controller before opening Godot
- Press a button on the controller to "wake" it up
- Check Project Settings → Input Map → your action → add gamepad input

### Game runs slow
- Close other programs
- Godot 2D games should run smoothly on most computers
- If issues persist, check your graphics drivers are up to date

---

## Next Steps

### Want to modify the game?

1. **Change frog speed**: Open `game/frog/frog.gd`, find `move_speed`
2. **Change jump height**: Open `game/frog/frog.gd`, find `jump_force`
3. **Add more time**: Open `game/autoload/game_state.gd`, find `round_time`
4. **Change controls**: Project → Project Settings → Input Map

### Want to learn more?

- [Learn GDScript From Zero](https://gdquest.itch.io/learn-godot-gdscript) - Free interactive tutorial
- [Godot Docs: Your First 2D Game](https://docs.godotengine.org/en/stable/getting_started/first_2d_game/)
- [GDQuest YouTube Channel](https://www.youtube.com/c/gdquest) - Video tutorials

---

## Verification Checklist

After setup, verify everything works:

- [ ] Godot opens the project without errors
- [ ] F5 runs the game
- [ ] Player 1 can move and jump (WASD)
- [ ] Player 2 can move and jump (Arrow keys)
- [ ] Both players can attack (E and /)
- [ ] Score updates when catching flies
- [ ] Game ends after 60 seconds
- [ ] Can pause with Escape
- [ ] (Optional) Gamepad works for both players
