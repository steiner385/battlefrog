# BattleFrog 🐸

A fun 2D platformer where frogs catch flies with their tongues! Built with Godot 4.x as a learning project.

## Features

- **Single Player Mode**: Control a frog, catch flies, and beat your high score
- **Co-op Mode**: Two players work together with a shared score
- **Competitive Mode**: Two players compete for the highest score
- **Frog Combat**: In competitive mode, stun your opponent with tongue attacks!

## Quick Start

### Prerequisites

- [Godot 4.x](https://godotengine.org/download) (Standard version, not .NET)

### Running the Game

1. Open Godot Engine
2. Click "Import" and select the `project.godot` file in this directory
3. Press F5 or click the Play button (▶)

### Controls

**Player 1:**
- Move: A/D or Arrow Keys
- Jump: W or Space
- Attack: E or Left Shift
- Pause: Escape

**Player 2:**
- Move: Arrow Keys
- Jump: Up Arrow
- Attack: / (Slash) or Right Shift

**Gamepad Support:** Both players can use Xbox/PlayStation controllers!

## Project Structure

```
battlefrog/
├── game/               # Game code and scenes
│   ├── main.tscn      # Main game scene
│   ├── frog/          # Frog character
│   ├── fly/           # Fly enemy
│   ├── tongue/        # Tongue attack
│   ├── ui/            # Menu, HUD, pause screens
│   └── autoload/      # Global game state
├── assets/            # Sprites and sounds
├── specs/             # Design documents
└── project.godot      # Godot project file
```

## Game Design

This project follows a specification-driven development approach:
- All design documents are in `specs/001-core-gameplay/`
- Features are prioritized and tested incrementally
- Code follows learning-friendly principles (<100 lines per file)

## Learning Resources

- [Godot Documentation](https://docs.godotengine.org/)
- [Learn GDScript From Zero](https://gdquest.itch.io/learn-godot-gdscript)
- [GDQuest Tutorials](https://www.gdquest.com/)

## License

This is a learning project. Feel free to use it for educational purposes!
