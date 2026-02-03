# BattleFrog - Debugging Guide

## Project Validation ✅

All project files are present and configured correctly!

## Launch Instructions

### Method 1: Using Godot Editor (Recommended)
1. Download [Godot 4.x](https://godotengine.org/download) (Standard version)
2. Extract and run the Godot executable
3. Click **"Import"** in the Project Manager
4. Navigate to: `c:\Users\tony\GitHub\battlefrog\project.godot`
5. Click **"Import & Edit"**
6. Press **F5** or click the **Play** button (▶)

### Method 2: Debug Launch (With Console Output)
1. Double-click `launch_debug.bat` in this folder
2. This will show console output for debugging any errors

## Common Issues & Solutions

### Issue: "Failed to load scene"
**Solution:** Make sure you opened the project in Godot 4.x (not 3.x)

### Issue: "Invalid scene format"
**Solution:** Re-import the project in Godot Editor

### Issue: "Script error" or "Parse error"
**Solution:** Run the validation script:
```powershell
.\validate.ps1
```

### Issue: Missing sounds
**Solution:** Regenerate sound files:
```powershell
cd assets\sounds
.\generate_sounds.ps1
```

## Project Structure

```
battlefrog/
├── game/
│   ├── autoload/
│   │   └── game_state.gd      # Global game state
│   ├── frog/
│   │   ├── frog.tscn          # Frog scene
│   │   └── frog.gd            # Frog controller (69 lines)
│   ├── fly/
│   │   ├── fly.tscn           # Fly scene
│   │   └── fly.gd             # Fly AI (48 lines)
│   ├── tongue/
│   │   ├── tongue.tscn        # Tongue attack
│   │   └── tongue.gd          # Tongue mechanics (85 lines)
│   ├── ui/
│   │   ├── menu.tscn/gd       # Main menu
│   │   ├── hud.tscn/gd        # Score/timer display
│   │   ├── pause.tscn/gd      # Pause menu
│   │   └── game_over.tscn/gd  # End screen
│   ├── main.tscn              # Main game scene
│   └── main.gd                # Game loop (57 lines)
├── assets/
│   ├── sprites/
│   │   └── icon.svg           # Game icon
│   └── sounds/
│       ├── jump.wav           # Jump sound
│       ├── catch.wav          # Catch sound
│       ├── stun.wav           # Stun sound
│       └── menu_select.wav    # Menu sound
└── project.godot              # Godot configuration

✅ All 9 scripts under 100 lines (learning-friendly!)
```

## Validation Status

Run `.\validate.ps1` to check:
- ✅ Project file exists
- ✅ Main scene configured
- ✅ Autoload scripts present
- ✅ All core scenes exist
- ✅ 9 GDScript files found
- ✅ No syntax errors
- ✅ 4 sound files generated

## Controls

**Player 1:** WASD + E  
**Player 2:** Arrow Keys + /  
**Pause:** Escape  
**Gamepad:** Fully supported!

## Game Modes

- **Co-op Mode:** Work together, shared score
- **Competitive Mode:** Compete for highest score + frog combat!

---

**Need help?** Make sure you're using Godot 4.x and all files passed validation.
