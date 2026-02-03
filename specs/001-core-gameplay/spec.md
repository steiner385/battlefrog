# Feature Specification: Core Gameplay

**Feature Branch**: `001-core-gameplay`
**Created**: 2026-02-02
**Status**: Draft
**Input**: User description: "Core gameplay - frogs catching flies with tongue attacks in co-op and competitive two-player modes"

## Clarifications

### Session 2026-02-02

- Q: What is the game view perspective? → A: Side-view/platformer (frogs seen from the side, like in a 2D platformer)
- Q: How should the tongue attack direction work? → A: Forward only (tongue shoots in the direction the frog is facing)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Single Frog Movement and Fly Catching (Priority: P1)

A player controls a frog that can move around the screen and catch flies using a tongue attack. This is the fundamental mechanic that everything else builds upon.

**Why this priority**: Without basic frog control and fly catching, there is no game. This is the MVP that proves the core loop is fun.

**Independent Test**: Can be fully tested with one player controlling one frog, catching flies that spawn on screen. Delivers the core "catch flies" satisfaction.

**Acceptance Scenarios**:

1. **Given** a frog on screen, **When** the player presses left/right keys, **Then** the frog moves smoothly in that direction; **When** the player presses jump, **Then** the frog jumps and gravity brings it back down
2. **Given** a frog facing a fly within tongue range (horizontally in front), **When** the player presses the attack button, **Then** the frog's tongue shoots forward, catches the fly, and retracts
3. **Given** a frog catches a fly, **When** the tongue retracts, **Then** the player's score increases and the fly disappears
4. **Given** a fly on screen, **When** the fly is not caught within a time limit, **Then** the fly escapes (flies away) and the player loses a potential point

---

### User Story 2 - Two-Player Co-op Mode (Priority: P2)

Two players work together on the same screen to catch as many flies as possible before time runs out or flies escape. Both frogs help each other reach a shared high score.

**Why this priority**: Multiplayer is a core requirement. Co-op is simpler than competitive (no collision/conflict between players) and delivers the "play together" experience.

**Independent Test**: Can be tested with two players using separate controls, both catching flies, with a shared score displayed. Success when both players feel they're contributing.

**Acceptance Scenarios**:

1. **Given** co-op mode is selected, **When** the game starts, **Then** two frogs appear on screen with separate controls for each player
2. **Given** two frogs in co-op mode, **When** either frog catches a fly, **Then** the shared team score increases
3. **Given** a co-op game in progress, **When** the round ends, **Then** both players see the combined score and can choose to play again
4. **Given** two players, **When** both try to catch the same fly, **Then** only one frog catches it (first tongue to reach) and the score increases once

---

### User Story 3 - Two-Player Competitive Mode (Priority: P3)

Two players compete against each other to catch the most flies. The player with the higher score at the end wins. Optionally, frogs can interfere with each other.

**Why this priority**: Adds replayability and excitement after co-op is working. Requires score separation and win/lose conditions.

**Independent Test**: Can be tested with two players competing, each with their own score. Winner is clearly announced at end.

**Acceptance Scenarios**:

1. **Given** competitive mode is selected, **When** the game starts, **Then** two frogs appear with separate scores displayed for each player
2. **Given** a competitive game, **When** a frog catches a fly, **Then** only that player's score increases
3. **Given** a competitive game ends, **When** scores are compared, **Then** the player with more points is announced as winner
4. **Given** a tie score, **When** the game ends, **Then** both players are shown as tied

---

### User Story 4 - Frog vs Frog Combat (Priority: P4)

In competitive mode, players can choose to attack each other's frogs with their tongues. A hit stuns the opponent briefly, giving an advantage in fly catching.

**Why this priority**: Adds depth to competitive mode but not essential for basic competition. Can be added after basic competitive works.

**Independent Test**: Can be tested with two players in competitive mode attempting to tongue-attack each other. Success when stun mechanic feels fair and fun.

**Acceptance Scenarios**:

1. **Given** competitive mode with combat enabled, **When** a frog's tongue hits the other frog, **Then** the hit frog is stunned briefly and cannot move or attack
2. **Given** a stunned frog, **When** the stun duration ends, **Then** the frog regains full control
3. **Given** frog combat is happening, **When** a frog is stunned, **Then** a visual effect clearly shows the stunned state

---

### Edge Cases

- What happens when a player presses attack while the tongue is already extended? (Answer: Input is ignored until tongue retracts)
- What happens when both frogs' tongues reach a fly at exactly the same time? (Answer: Randomly pick one winner; rare enough that fairness averages out)
- What happens when a player disconnects their controller mid-game? (Answer: Pause game and show reconnection prompt)
- What happens when no flies are on screen? (Answer: New flies spawn continuously up to a maximum count)
- What happens when a frog moves off the edge of the screen? (Answer: Frog stops at screen boundary, cannot leave play area)

## Requirements *(mandatory)*

### Functional Requirements

**Frog Control**
- **FR-001**: Players MUST be able to move their frog left/right and jump (side-view platformer controls)
- **FR-002**: Players MUST be able to trigger a tongue attack with a single button press
- **FR-003**: The tongue MUST extend forward (in the direction the frog is facing), then retract automatically
- **FR-004**: Frogs MUST be confined to the visible play area

**Fly Behavior**
- **FR-005**: Flies MUST spawn at random positions on screen
- **FR-006**: Flies MUST move in unpredictable patterns to create challenge
- **FR-007**: Flies MUST be catchable when the tongue touches them
- **FR-008**: Caught flies MUST disappear and add to the catching player's score

**Game Modes**
- **FR-009**: Players MUST be able to select between co-op mode and competitive mode before starting
- **FR-010**: Co-op mode MUST use a single shared score for both players
- **FR-011**: Competitive mode MUST track separate scores for each player
- **FR-012**: Games MUST have a clear end condition (time limit or fly quota)

**Two-Player Support**
- **FR-013**: Two players MUST be able to play simultaneously on the same screen
- **FR-014**: Each player MUST have dedicated controls that do not conflict
- **FR-015**: Both players MUST see their frog's status and relevant scores at all times

**Combat (Competitive Mode)**
- **FR-016**: In competitive mode, tongue attacks MUST be able to hit the opposing frog
- **FR-017**: A hit frog MUST become stunned and unable to act for a brief duration
- **FR-018**: Stunned state MUST be clearly visible to both players

**Input Support**
- **FR-019**: Game MUST support keyboard input for both players
- **FR-020**: Game MUST support gamepad input for both players

### Key Entities

- **Frog**: The player-controlled character. Has position, facing direction (left or right), player owner (1 or 2), current state (normal, jumping, attacking, stunned), and score (in competitive mode)
- **Tongue**: The frog's attack. Has extended/retracted state, length, position relative to frog, and can detect collision with flies or other frogs
- **Fly**: The target to catch. Has position, movement pattern, and point value
- **Game Session**: A single round of play. Has game mode (co-op/competitive), time remaining, score(s), and active players
- **Player**: A human participant. Has assigned frog, input device, and control bindings

## Assumptions

- **Visual perspective**: Side-view platformer (2D, frogs seen from the side with gravity affecting movement)
- Players are sitting at the same computer (local multiplayer only, no online)
- Standard PC with keyboard and optional gamepads is the target hardware
- Games are short sessions (1-3 minutes) for quick fun
- Default time limit per round: 60 seconds
- Default maximum flies on screen: 5
- Default stun duration: 1 second
- Tongue range: approximately 1/4 of screen width
- Keyboard controls: Player 1 uses WASD + Space, Player 2 uses Arrow Keys + Enter

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A new player can understand how to move and catch flies within 30 seconds of starting
- **SC-002**: Both players can play a complete round without control confusion or overlap
- **SC-003**: Players can complete 3 consecutive games without any freezes or glitches
- **SC-004**: A 12-year-old can read the code for frog movement and explain what it does
- **SC-005**: Game maintains smooth visuals (no stuttering) during normal play
- **SC-006**: Players report the game is "fun" after a 5-minute play session
- **SC-007**: The winner of competitive mode matches the player with the higher score 100% of the time
- **SC-008**: Co-op score equals the sum of flies caught by both players
