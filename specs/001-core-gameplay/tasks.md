# Tasks: Core Gameplay

**Input**: Design documents from `/specs/001-core-gameplay/`
**Prerequisites**: plan.md, spec.md, data-model.md, contracts/

**Tests**: Manual playtesting is the primary test approach for this learning project. No automated test tasks included unless specifically requested.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3, US4)
- Include exact file paths in descriptions

## Path Conventions

This is a Godot 4.x project:
- **Scenes**: `.tscn` files define visual layout
- **Scripts**: `.gd` files contain GDScript logic
- **Autoloads**: Global scripts registered in Project Settings

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Initialize Godot project and create folder structure

- [x] T001 Create Godot 4.x project with project.godot at repository root
- [x] T002 Create folder structure: game/, game/frog/, game/fly/, game/tongue/, game/ui/, game/autoload/, assets/sprites/, assets/sounds/
- [x] T003 [P] Configure input actions in Project Settings for player1_left, player1_right, player1_jump, player1_attack per contracts/input-actions.md
- [x] T004 [P] Add placeholder sprite images in assets/sprites/ (frog.png, fly.png, tongue.png, background.png)

**Checkpoint**: Project opens in Godot without errors, folder structure visible, input actions defined

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core autoloads and base scene that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T005 Create game_state.gd autoload in game/autoload/game_state.gd with properties: game_mode, game_state, time_remaining, team_score, player1_score, player2_score, max_flies
- [x] T006 Register game_state.gd as AutoLoad named "GameState" in Project Settings
- [x] T007 Create main.tscn scene in game/main.tscn with Node2D root, Camera2D, and placeholder background
- [x] T008 Create main.gd script in game/main.gd attached to main.tscn root with _ready() and _process(delta) functions
- [x] T009 Set game/main.tscn as the Main Scene in Project Settings → Application → Run

**Checkpoint**: Game launches with F5, shows background, GameState autoload accessible from any script

---

## Phase 3: User Story 1 - Single Frog Movement and Fly Catching (Priority: P1) 🎯 MVP

**Goal**: One player can control a frog, move left/right, jump, and catch flies with tongue attack. Score increases when flies are caught.

**Independent Test**: Press F5, move frog with WASD, jump with Space, attack with E. Catch a fly and see score increase. This is the complete MVP.

### Implementation for User Story 1

- [x] T010 [P] [US1] Create frog.tscn scene in game/frog/frog.tscn with CharacterBody2D root, Sprite2D, CollisionShape2D
- [x] T011 [P] [US1] Create fly.tscn scene in game/fly/fly.tscn with Area2D root, Sprite2D, CollisionShape2D
- [x] T012 [P] [US1] Create tongue.tscn scene in game/tongue/tongue.tscn with Area2D root, Sprite2D (stretchable), CollisionShape2D
- [x] T013 [US1] Create frog.gd script in game/frog/frog.gd with movement (left/right), jump with gravity, facing direction, and attack trigger
- [x] T014 [US1] Create tongue.gd script in game/tongue/tongue.gd with extend/retract states, collision detection, signals for hit_fly and hit_frog
- [x] T015 [US1] Create fly.gd script in game/fly/fly.gd with random movement pattern, escape timer, caught signal, queue_free on catch
- [x] T016 [US1] Add tongue as child of frog scene, connect attack input to tongue extend in frog.gd
- [x] T017 [US1] Update main.gd to instance one frog at start position, spawn flies up to max_flies count
- [x] T018 [US1] Create hud.tscn scene in game/ui/hud.tscn with Label nodes for score and timer display
- [x] T019 [US1] Create hud.gd script in game/ui/hud.gd that listens to GameState.score_changed signal and updates display
- [x] T020 [US1] Connect fly.caught signal to GameState to increment score, connect GameState.score_changed to HUD
- [x] T021 [US1] Add timer countdown in main.gd, emit GameState.game_over when time reaches 0
- [x] T022 [US1] Add screen boundaries to prevent frog from leaving visible area in frog.gd

**Checkpoint**: Single player can play complete game loop: move, jump, catch flies, see score, game ends when timer expires

---

## Phase 4: User Story 2 - Two-Player Co-op Mode (Priority: P2)

**Goal**: Two players on same screen, both catching flies, shared team score displayed.

**Independent Test**: Start game, P1 uses WASD+E, P2 uses Arrows+Slash. Both can catch flies. One shared score shown. Game ends after 60 seconds.

### Implementation for User Story 2

- [x] T023 [P] [US2] Add player2 input actions in Project Settings: player2_left, player2_right, player2_jump, player2_attack per contracts/input-actions.md
- [x] T024 [US2] Add player_number property to frog.gd, modify input handling to use player-specific actions (player1_left vs player2_left)
- [x] T025 [US2] Update main.gd to instance two frogs at different start positions when game starts
- [x] T026 [US2] Ensure GameState.team_score is used when game_mode is "coop", both frogs' catches add to same score
- [x] T027 [US2] Update hud.gd to show single "Team Score" label in co-op mode
- [x] T028 [US2] Create menu.tscn scene in game/ui/menu.tscn with buttons for "Co-op Mode" and "Competitive Mode"
- [x] T029 [US2] Create menu.gd script in game/ui/menu.gd that sets GameState.game_mode and transitions to main scene
- [x] T030 [US2] Update main.gd to read GameState.game_mode and configure accordingly

**Checkpoint**: Two players can play co-op, catching flies together with shared score. Menu allows mode selection.

---

## Phase 5: User Story 3 - Two-Player Competitive Mode (Priority: P3)

**Goal**: Two players compete, each has own score, winner announced at end.

**Independent Test**: Select Competitive from menu. Both players catch flies. Separate scores shown. At game end, winner displayed.

### Implementation for User Story 3

- [x] T031 [US3] Update GameState to track player1_score and player2_score separately when game_mode is "competitive"
- [x] T032 [US3] Modify fly.caught signal to include which frog caught it, update correct player's score
- [x] T033 [US3] Update hud.gd to show two separate score labels in competitive mode (P1 Score, P2 Score)
- [x] T034 [US3] Create game_over.tscn scene in game/ui/game_over.tscn with winner announcement Label and "Play Again" button
- [x] T035 [US3] Create game_over.gd script in game/ui/game_over.gd that compares scores and displays winner (or "Tie!")
- [x] T036 [US3] Update main.gd to transition to game_over scene when timer expires

**Checkpoint**: Competitive mode fully works - separate scores, winner announced, can replay

---

## Phase 6: User Story 4 - Frog vs Frog Combat (Priority: P4)

**Goal**: In competitive mode, frogs can stun each other with tongue attacks.

**Independent Test**: In competitive mode, hit other frog with tongue. They freeze briefly with visual effect. After 1 second, they can move again.

### Implementation for User Story 4

- [x] T037 [US4] Add "stunned" state to frog.gd with stun_timer, disable input while stunned
- [x] T038 [US4] Update tongue.gd to detect collision with other frog (check is_in_group("frogs")), emit hit_frog signal
- [x] T039 [US4] Add frogs to "frogs" group in frog.gd _ready() function
- [x] T040 [US4] Connect tongue.hit_frog signal to target frog's stun function, only in competitive mode
- [x] T041 [US4] Add visual stun effect in frog.gd (modulate color change or shake animation)
- [x] T042 [US4] Add stun recovery: after stun_duration (1 second), return to normal state

**Checkpoint**: Combat works - frogs can stun each other, visual feedback is clear, 1-second recovery

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final improvements affecting all stories

- [x] T043 [P] Add placeholder sound effects in assets/sounds/ (jump.wav, catch.wav, stun.wav, menu_select.wav)
- [x] T044 [P] Add sound playback in frog.gd for jump, tongue.gd for catch, menu.gd for selection
- [x] T045 Add pause functionality: Escape key pauses game, shows simple pause overlay
- [x] T046 Add gamepad support: verify all input actions work with Xbox/PlayStation controller
- [x] T047 Run quickstart.md verification checklist to confirm all features work
- [x] T048 Code review: verify all .gd files are under 100 lines per constitution requirement

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational - this is the MVP
- **User Story 2 (Phase 4)**: Depends on US1 (needs frog/fly/tongue working)
- **User Story 3 (Phase 5)**: Depends on US2 (needs two-player working)
- **User Story 4 (Phase 6)**: Depends on US3 (needs competitive mode working)
- **Polish (Phase 7)**: Depends on all desired user stories being complete

### User Story Dependencies

```text
Phase 1: Setup
    ↓
Phase 2: Foundational
    ↓
Phase 3: US1 (MVP) ← Stop here for minimal playable game
    ↓
Phase 4: US2 (Co-op) ← Stop here for two-player co-op
    ↓
Phase 5: US3 (Competitive) ← Stop here for both modes
    ↓
Phase 6: US4 (Combat) ← Full feature set
    ↓
Phase 7: Polish
```

### Within Each User Story

- Scenes (.tscn) can be created in parallel [P]
- Scripts (.gd) depend on their scenes existing
- Signal connections depend on both emitter and receiver existing
- Integration tasks come last in each phase

### Parallel Opportunities

- T003, T004 can run in parallel (different concerns)
- T010, T011, T012 can run in parallel (different scene files)
- T023 can run in parallel with other US2 tasks (just settings)
- T043, T044 can run in parallel (different file types)

---

## Parallel Example: User Story 1 Scenes

```bash
# These three scene creation tasks can run in parallel:
Task T010: "Create frog.tscn scene in game/frog/frog.tscn"
Task T011: "Create fly.tscn scene in game/fly/fly.tscn"
Task T012: "Create tongue.tscn scene in game/tongue/tongue.tscn"

# Then these script tasks (after scenes exist):
Task T013: "Create frog.gd script in game/frog/frog.gd"
Task T014: "Create tongue.gd script in game/tongue/tongue.gd"
Task T015: "Create fly.gd script in game/fly/fly.gd"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only) - RECOMMENDED FOR LEARNING

1. Complete Phase 1: Setup (T001-T004)
2. Complete Phase 2: Foundational (T005-T009)
3. Complete Phase 3: User Story 1 (T010-T022)
4. **STOP and PLAYTEST**: Can you move, jump, catch flies, see score?
5. If yes, you have a working game! Celebrate!

### Incremental Delivery

1. **MVP (US1)**: Single player catches flies → Playable game
2. **Add Co-op (US2)**: Two players, shared score → Play together
3. **Add Competitive (US3)**: Separate scores, winner → Compete
4. **Add Combat (US4)**: Stun mechanic → Full depth
5. **Polish**: Sound, pause, controllers → Polished experience

### Learning Approach

Since this is a learning project with a 12-year-old:

1. **Do US1 together** - Learn core Godot concepts (scenes, scripts, signals)
2. **US2 is similar** - Reinforce learning with two-player extension
3. **US3 adds logic** - Learn state management and conditions
4. **US4 is optional** - Add if time permits and interest remains
5. **Polish is fun** - Sound effects and gamepad feel rewarding

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story checkpoint = playable game increment
- Test by playing after each checkpoint
- Keep each .gd file under 100 lines (split if needed)
- Commit after each task or logical group
- Have fun! This is a game, after all 🐸
