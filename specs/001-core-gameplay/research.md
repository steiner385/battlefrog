# Research: Core Gameplay Technical Decisions

**Feature**: 001-core-gameplay
**Date**: 2026-02-02

## Decision 1: Game Framework

### Decision: Godot 4 with GDScript

### Rationale

Godot with GDScript is the best choice for a learning project with a 12-year-old:

1. **Scratch-like Visual Experience**: The scene editor provides drag-and-drop game object placement, similar to Scratch's stage, easing the transition to text-based coding.

2. **Python-like Syntax**: GDScript looks like Python but is simpler for game-specific tasks. Learning it transfers to Python later.

3. **All Requirements Met**:
   - 2D platformer: Built-in CharacterBody2D with physics
   - Local two-player: Input map system with player-specific actions
   - Keyboard + Gamepad: Native support with visual binding editor
   - Windows PC: Excellent support with one-click export

4. **Best Learning Resources for Kids**: GDQuest's "Learn GDScript From Zero" is a free, browser-based, interactive tutorial for complete beginners.

5. **Professional Yet Accessible**: Unlike toy frameworks, Godot is used to make commercial games - a real tool to grow into.

### Alternatives Considered

| Framework | Pros | Cons | Why Rejected |
|-----------|------|------|--------------|
| Pygame Zero | Simplest code, great for beginners | **No native gamepad support** | Doesn't meet FR-020 (gamepad input) |
| Full Pygame | Full gamepad support, huge community | More boilerplate, harder to keep <100 LOC | Too complex for learning-friendly code |
| Phaser (JS) | Web-based, good docs | JavaScript less beginner-friendly | Harder transition from Scratch |
| Love2D (Lua) | Simple, good gamepad support | Lua less transferable skill | GDScript more useful long-term |

---

## Decision 2: Testing Approach

### Decision: Manual playtesting with simple GDScript unit tests

### Rationale

For a learning project with a beginner:

1. **Primary testing is playtesting** - Playing the game together teaches debugging and iteration
2. **Simple unit tests** for core logic (scoring, collision rules) teach testing concepts
3. **Godot's built-in test framework** (GUT - Godot Unit Test) is available if needed
4. **Keep it simple** - Don't overwhelm with TDD for a first project

### Implementation

- Core game rules (scoring, win conditions) will have simple test functions
- Collision detection will be verified through play
- Constitution principle IV (Testable Mechanics) met through deterministic game logic

---

## Decision 3: Project Structure

### Decision: Flat scene-based structure with one script per concept

### Rationale

Following Constitution principle VI (Learning-Friendly Code):

1. **One scene per game object**: frog.tscn, fly.tscn, tongue.tscn
2. **One script per scene**: Each .gd file attached to its scene
3. **Flat folder structure**: No deep nesting
4. **Clear naming**: frog.gd, fly.gd, game.gd, menu.gd

### Structure

```text
project.godot           # Godot project file
game/
├── main.tscn          # Main game scene
├── main.gd            # Game logic
├── frog/
│   ├── frog.tscn      # Frog scene (sprite, collision, etc.)
│   └── frog.gd        # Frog movement and attack
├── fly/
│   ├── fly.tscn       # Fly scene
│   └── fly.gd         # Fly movement
├── tongue/
│   ├── tongue.tscn    # Tongue scene
│   └── tongue.gd      # Tongue extension/collision
├── ui/
│   ├── hud.tscn       # Score display
│   ├── menu.tscn      # Main menu
│   └── game_over.tscn # Game over screen
└── autoload/
    ├── game_state.gd  # Global game state (scores, mode)
    └── settings.gd    # Game settings

assets/
├── sprites/           # Character and background images
└── sounds/            # Sound effects
```

**Note**: Godot uses scenes (.tscn) for visual layout and scripts (.gd) for code. This separation keeps code files small while the visual editor handles positioning, sprites, and collision shapes.

---

## Decision 4: Storage

### Decision: Godot's built-in ConfigFile for high scores

### Rationale

1. **Simple API**: ConfigFile is Godot's built-in way to save/load data
2. **Human-readable**: Saves as .cfg text file, easy to understand
3. **No database needed**: Local file is sufficient for high scores
4. **Learning opportunity**: Teaches file I/O concepts simply

### Example

```gdscript
# Saving high score
var config = ConfigFile.new()
config.set_value("scores", "high_score", 100)
config.save("user://highscores.cfg")

# Loading high score
config.load("user://highscores.cfg")
var high_score = config.get_value("scores", "high_score", 0)
```

---

## Technical Context Resolution

| Item | Resolution |
|------|------------|
| Language/Version | GDScript (Godot 4.x) |
| Primary Dependencies | Godot Engine 4.x |
| Storage | ConfigFile for high scores |
| Testing | Manual playtesting + simple unit tests |
| Target Platform | Windows PC (Godot export) |
| Performance | Godot handles 60 FPS easily for 2D |

---

## Learning Resources

### For Getting Started
- [Learn GDScript From Zero](https://gdquest.itch.io/learn-godot-gdscript) - Free interactive browser tutorial
- [GDQuest Beginner Learning Path](https://www.gdquest.com/tutorial/godot/learning-paths/beginner/)
- [Godot Official 2D Platformer Tutorial](https://docs.godotengine.org/en/stable/getting_started/first_2d_game/)

### For Two-Player Input
- [GDQuest Local Multiplayer Input Tutorial](https://www.gdquest.com/tutorial/godot/2d/local-multiplayer-input/)
- [Godot Input Map Documentation](https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html)
