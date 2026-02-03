<!--
  Sync Impact Report
  ===================
  Version change: 1.0.0 → 1.1.0 (added learning-focused principle)

  Modified principles: None

  Added sections:
  - VI. Learning-Friendly Code (new principle for beginner accessibility)

  Removed sections: None

  Templates requiring updates:
  - .specify/templates/plan-template.md: ✅ compatible (no changes needed)
  - .specify/templates/spec-template.md: ✅ compatible (no changes needed)
  - .specify/templates/tasks-template.md: ✅ compatible (no changes needed)

  Follow-up TODOs: None
-->

# BattleFrog Constitution

## Core Principles

### I. Gameplay First

All features MUST serve the core gameplay loop: frogs battling flies and optionally each other.
- Every mechanic MUST be fun for both solo practice and two-player sessions
- New features MUST NOT disrupt the balance between co-op and competitive modes
- Visual/audio feedback MUST clearly communicate game state changes to players
- Rationale: A game that isn't fun fails regardless of technical excellence

### II. Multiplayer Parity

Both players MUST have equivalent capabilities and experience.
- Frog characters MUST have balanced abilities (no pay-to-win, no unfair advantages)
- Input latency MUST be consistent across both local player slots
- Both players MUST be able to see relevant game information equally
- Co-op mode and competitive mode MUST both be first-class experiences
- Rationale: Unfair multiplayer drives players away

### III. Clear Game States

The game MUST communicate state unambiguously to all players.
- Game modes (co-op vs competitive) MUST be visually distinct
- Player health, score, and status MUST be visible at all times
- Transitions between states (menu, playing, paused, game over) MUST be explicit
- Enemy (fly) behavior MUST be predictable and learnable
- Rationale: Confusion breaks immersion and causes player frustration

### IV. Testable Mechanics

All game mechanics MUST be independently verifiable.
- Combat systems MUST have deterministic outcomes given the same inputs
- Collision detection MUST be consistent and reproducible
- Game rules MUST be expressible as testable conditions
- Multiplayer synchronization MUST be verifiable in automated tests
- Rationale: Untestable code leads to regression bugs that destroy player trust

### V. Performance Budget

The game MUST maintain smooth performance on target hardware.
- Frame rate MUST target 60 FPS minimum on mid-range PC hardware
- Input-to-response latency MUST NOT exceed 100ms
- Memory usage MUST remain stable during extended play sessions
- Loading times MUST NOT exceed 5 seconds for any transition
- Rationale: Poor performance ruins the action game experience

### VI. Learning-Friendly Code

Code MUST be accessible to a beginner learning to program (12-year-old with Scratch experience).
- Files MUST be short and focused (target <100 lines per file)
- Variable and function names MUST be descriptive and use plain English
- Each file MUST do ONE clear thing (single responsibility)
- Complex logic MUST be broken into small, named functions with clear purposes
- Comments MUST explain "why" in simple language, not repeat "what" the code does
- Folder structure MUST be flat and intuitive (avoid deep nesting)
- Code patterns MUST be consistent so learning one file helps understand others
- New concepts MUST be introduced gradually, one at a time
- Rationale: The project's secondary goal is teaching programming; overwhelming complexity defeats learning

## Platform & Technical Constraints

- **Target Platform**: Windows PC (primary), with architecture supporting future platform expansion
- **Player Count**: Two-player local multiplayer required; online multiplayer is out of initial scope
- **Input Support**: MUST support keyboard and gamepad input for both players
- **Resolution**: MUST support common PC resolutions (1080p minimum, 4K desirable)
- **Audio**: MUST support stereo audio with distinct feedback for game events
- **Beginner Tools**: SHOULD prefer frameworks/engines with visual editors and live preview

## Development Workflow

- **Feature Development**: All features MUST be specified before implementation begins
- **Playtesting**: Every gameplay change MUST be playtested in both co-op and competitive modes
- **Code Review**: Changes affecting multiplayer parity MUST be reviewed for balance implications
- **Build Verification**: Every commit MUST pass automated tests and maintain performance budgets
- **Version Control**: Main branch MUST always be in a playable state
- **Pair Programming**: Code sessions SHOULD involve both developers working together
- **Incremental Progress**: Features SHOULD be built in small, visible increments that can be tested immediately

## Governance

This constitution defines the non-negotiable principles for BattleFrog development.

- **Precedence**: Constitution principles supersede implementation convenience
- **Amendments**: Changes to principles require documentation of rationale and impact assessment
- **Compliance**: All pull requests MUST verify adherence to applicable principles
- **Exceptions**: Temporary violations MUST be documented with remediation plans
- **Review Cadence**: Constitution SHOULD be reviewed when adding major features

**Version**: 1.1.0 | **Ratified**: 2026-02-02 | **Last Amended**: 2026-02-02
