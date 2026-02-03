# Implementation Plan: Core Gameplay

**Branch**: `001-core-gameplay` | **Date**: 2026-02-02 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-core-gameplay/spec.md`

## Summary

Build a 2D side-view platformer where frogs catch flies with tongue attacks. Supports two-player local multiplayer with both co-op (shared score) and competitive (separate scores + combat) modes. Code must be beginner-friendly for a 12-year-old learning to program.

## Technical Context

**Language/Version**: GDScript (Godot 4.x)
**Primary Dependencies**: Godot Engine 4.x
**Storage**: ConfigFile for high scores (user://highscores.cfg)
**Testing**: Manual playtesting + simple GDScript unit tests for core logic
**Target Platform**: Windows PC (Godot export)
**Project Type**: Single Godot project (2D game)
**Performance Goals**: 60 FPS, <100ms input latency (per constitution)
**Constraints**: <100 lines per file, flat folder structure, beginner-readable code
**Scale/Scope**: Small game, 2 players, ~5 screens (menu, game, pause, game over, settings)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Requirement | Status |
|-----------|-------------|--------|
| I. Gameplay First | Core loop serves fun | ✅ Spec prioritizes gameplay |
| II. Multiplayer Parity | Both players equal | ✅ Same frog abilities, separate controls |
| III. Clear Game States | Visible status/feedback | ✅ Scores, states defined in spec |
| IV. Testable Mechanics | Deterministic outcomes | ✅ Collision, scoring are testable |
| V. Performance Budget | 60 FPS, <100ms latency | ✅ Godot handles 2D easily at 60 FPS |
| VI. Learning-Friendly | <100 LOC files, simple names | ✅ Scene/script separation keeps files small |

**Gate Status**: ✅ PASS - All principles satisfied with Godot + GDScript choice.

## Project Structure

### Documentation (this feature)

```text
specs/001-core-gameplay/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (game events/interfaces)
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
project.godot              # Godot project file

game/
├── main.tscn              # Main game scene
├── main.gd                # Game loop and state management
├── frog/
│   ├── frog.tscn          # Frog scene (sprite, collision shape)
│   └── frog.gd            # Frog movement and attack logic
├── fly/
│   ├── fly.tscn           # Fly scene
│   └── fly.gd             # Fly movement patterns
├── tongue/
│   ├── tongue.tscn        # Tongue scene (area for collision)
│   └── tongue.gd          # Tongue extend/retract logic
├── ui/
│   ├── hud.tscn           # Score and timer display
│   ├── hud.gd             # HUD update logic
│   ├── menu.tscn          # Main menu
│   ├── menu.gd            # Menu navigation
│   └── game_over.tscn     # Game over screen
└── autoload/
    ├── game_state.gd      # Global: scores, game mode, player count
    └── input_manager.gd   # Global: player input mappings

assets/
├── sprites/               # Frog, fly, tongue, background images
└── sounds/                # Jump, catch, menu sounds

tests/
└── test_scoring.gd        # Unit tests for score calculations
```

**Structure Decision**: Godot scene-based structure with one script per scene. Visual elements (sprites, collision shapes) are in .tscn files, keeping .gd code files focused on logic only. Each folder represents one game concept.

## Complexity Tracking

> No violations - structure follows Learning-Friendly principle.

| Principle | Compliance |
|-----------|------------|
| <100 lines per file | ✅ Scene/script split keeps code small |
| Plain English names | ✅ frog.gd, fly.gd, tongue.gd |
| Single responsibility | ✅ One script per scene |
| Flat structure | ✅ Shallow nesting (game/frog/, game/fly/) |
| Consistent patterns | ✅ All game objects follow scene+script pattern |
