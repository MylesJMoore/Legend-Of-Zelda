# Official Documentation: Legend of Zelda Prototype

**Engine:** GameMaker Studio 2 (GML)
**Project Name (internal):** Legend Of Tesla
**Build:** Open-World Combat Prototype

---

## Overview

This is a top-down, Zelda-style action prototype built in GameMaker Studio 2. It features a fully playable player character with directional combat, a multi-state enemy AI system, a functioning HUD, and room-to-room transitions via warp blocks. The prototype runs at 320x240 pixels scaled 3x to a 960x720 window, matching the aesthetic of classic SNES/GBC-era Zelda titles.

---

## Engine and Project Configuration

- **View Resolution:** 320x240
- **Window Size:** 960x720 (3x scale)
- **Room Size:** 320x240
- **Input:** Keyboard and gamepad supported simultaneously

---

## Rooms

### Initialization Room

The startup room. Contains the persistent game manager (`iGame`) and the HUD object (`obj_hud`). On creation, the game manager immediately transitions to `MainRoom`. This room is used exclusively for global initialization.

### MainRoom

The primary gameplay arena. Contains the player, one Moblin enemy, wall collision objects, a background environment sprite, and a warp block for room transitions. Background color is a dark earthy brown.

---

## Objects

### iGame (Game Manager)

**Persistent:** Yes

Manages global game state. Initializes the following globals on creation:

- `global.game_mode` (empty string, reserved for mode switching)
- `global.rupees` (currency counter, starts at 0)
- `global.player_can_move` (boolean flag for cutscene or control lockout)
- `global.hitpause` (frame counter that freezes gameplay on combat impact)

Transitions to `MainRoom` automatically on creation. Tracks `last_room` for future use.

---

### obj_player (Player Character)

The core player object. Implements a 4-state machine: `IDLE`, `WALK`, `ATTACK`, and `HURT`.

#### Movement

- **Input:** Arrow keys or WASD for keyboard; D-pad or analog stick for gamepad
- **Run:** Hold Shift (keyboard) or B button (gamepad) to run
- **Walk Speed:** 2 pixels/frame
- **Run Speed:** 3 pixels/frame
- **Acceleration:** 0.4 (smooth ramp-up to max speed)
- **Deceleration:** 1.0 (snappy stop when input is released)
- **Analog Stick Deadzone:** 0.2 threshold; input below this is ignored
- **Diagonal Normalization:** Analog stick input is normalized so diagonal movement does not exceed max speed
- **Collision:** Wall collision using `place_meeting()` against `obj_wall`
- **Depth Sorting:** `depth = -bbox_bottom`, so objects lower on screen draw in front

#### Animation

Sprites are stored in arrays indexed by direction constant (RIGHT, UP, LEFT, DOWN, and their idle variants). The correct sprite is chosen each frame based on movement direction and state. The player's last non-idle direction is tracked as `facing_dir` and is used to aim attacks.

- Walking: directional walk sprites (right/up/left/down)
- Idle: directional idle sprites held when standing still
- Stab: directional attack sprites shown during the ATTACK state
- Hurt: directional hurt sprites shown during the HURT state

#### Combat: ATTACK State

- **Input:** Z key or Gamepad A button
- **Total Duration:** 14 frames
- **Hitbox Spawn Frame:** Frame 4 (gives 3 frames of anticipation before the hit window)
- **Hitbox Offset by Direction:**
  - RIGHT: +14px on X
  - LEFT: -14px on X
  - UP: -16px on Y
  - DOWN: -12px on Y
- The attack state plays the stab sprite in the current facing direction and returns to IDLE after 14 frames

#### HURT State

- Triggered when the player takes damage and is not invulnerable
- Duration: 20 frames
- Visual: Flashes red/white on an 8-frame cycle
- Returns to IDLE after duration ends

#### Invulnerability (I-Frames)

- Activated immediately when the player takes a hit
- Duration: 40 frames
- Prevents any further damage during this window
- Ticks down every step regardless of current state

---

### obj_stab_hitbox (Attack Hitbox)

A temporary invisible object spawned by the player during the ATTACK state. It handles hit detection, damage application, and the hitpause effect.

- **Lifetime:** 6 frames, then self-destructs
- **Hit Flag:** `hit_done` prevents the hitbox from triggering more than one hit per swing
- **Hitbox Size by Direction:**
  - Horizontal attacks (LEFT/RIGHT): 16x10 pixels
  - Vertical attacks (UP/DOWN): 10x16 pixels
- **Collision Check:** Uses `collision_rectangle()` against `obj_moblin`
- **On Hit:**
  - Reduces enemy `hp` by 1
  - If enemy HP reaches 0 or below, transitions the enemy to the DEAD state
  - Otherwise, transitions the enemy to STAGGER with knockback
  - Knockback direction is derived from the attack direction (0, 90, 180, or 270 degrees)
  - Triggers 4 frames of global hitpause via `global.hitpause`
- **Debug Draw:** Renders a red semi-transparent rectangle over the hitbox region (visible in play mode)

---

### obj_moblin (Enemy)

The primary enemy type. Implements a 6-state AI machine: `PATROL`, `ALERT`, `CHASE`, `ATTACK`, `STAGGER`, and `DEAD`.

#### Sprites

Walk and attack sprites are stored in arrays indexed by direction, identical in structure to the player's sprite system.

#### PATROL State

- The Moblin moves back and forth between two fixed patrol points
- Default patrol points are the spawn X position offset by +/-32 pixels
- **Speed:** 0.6 pixels/frame
- Facing direction is snapped to LEFT or RIGHT based on movement
- Each frame, checks if the player is within the aggro radius (64px); if so, transitions to ALERT

#### ALERT State

- The Moblin stops moving and flashes yellow (8-frame cycle)
- **Duration:** 30 frames
- Exists to give the player a visible warning before the chase begins
- After the timer expires, transitions to CHASE

#### CHASE State

- **Speed:** 1.1 pixels/frame
- Moves toward the player using `point_direction()` and `lengthdir_x/y()`
- **4-Directional Snapping:** The angle to the player is snapped into one of four quadrants for animation:
  - 45 to 135 degrees: UP
  - 135 to 225 degrees: LEFT
  - 225 to 315 degrees: DOWN
  - 315 to 45 degrees: RIGHT
- **Leash Radius:** 85px. If the player moves farther than this from the Moblin's current position, the Moblin gives up and returns to PATROL
- **Attack Trigger:** If the player is within 14px, transitions to ATTACK

#### ATTACK State

- **Duration:** 24 frames
- Plays the directional attack sprite
- **Hit Frame:** Frame 10 is when damage is checked
- At frame 10, if the player is still within 14px and not invulnerable:
  - Reduces player `hp` by 1
  - Sets player to HURT state
  - Activates player invulnerability
- After 24 frames, returns to CHASE

#### STAGGER State

- Triggered by the player's attack hitbox connecting
- **Duration:** 20 frames
- **Knockback:** Moves in the knockback direction at 2 pixels/frame for the first 14 frames
- Wall collision is respected during knockback (the Moblin stops if it hits a wall)
- Visual: Flashes red on a 4-frame cycle
- After the stagger timer expires, returns to the previous state (typically CHASE)

#### DEAD State

- Triggered when `hp` reaches 0
- **Duration:** 20 frames
- Alpha fades from 1.0 to 0.0 over the duration
- Self-destructs when the fade is complete

#### Enemy Stats

| Stat               | Value        |
| ------------------ | ------------ |
| Max HP             | 6            |
| Patrol Speed       | 0.6 px/frame |
| Chase Speed        | 1.1 px/frame |
| Aggro Radius       | 64 px        |
| Leash Radius       | 85 px        |
| Alert Duration     | 30 frames    |
| Attack Range       | 14 px        |
| Attack Duration    | 24 frames    |
| Attack Hit Frame   | Frame 10     |
| Stagger Duration   | 20 frames    |
| Knockback Speed    | 2 px/frame   |
| Knockback Duration | 14 frames    |
| Death Duration     | 20 frames    |

---

### obj_warp_block (Room Transition Trigger)

An invisible or sprite-covered trigger zone placed in the room. When the player overlaps it, it spawns `obj_warp` with the following data:

- `target_room`: the room to transition to
- `target_x`, `target_y`: where to place the player after the transition
- `target_face`: the direction the player should be facing after arrival

Guards against multiple spawns by checking `!instance_exists(obj_warp)` before spawning.

---

### obj_warp (Room Transition Effect)

Spawned by `obj_warp_block`. Plays a transition animation. When the animation ends (via the Animation End event), it:

1. Transitions to `target_room`
2. Moves the player to `target_x`, `target_y`
3. Sets `obj_player.facing_dir` to `target_face`

Self-destructs if it detects it is already in the target room and the animation is complete (handles edge cases on re-entry).

---

### obj_wall (Collision Geometry)

A static object with no events. Its only purpose is collision detection. Uses `spr_wall` as its sprite. Multiple instances are placed in rooms at various scales (0.5x, 4x) to build the level geometry.

---

### obj_hud (HUD Display)

A persistent GUI overlay rendered on the GUI layer (so it is not affected by camera movement). The HUD occupies a 48px-tall strip at the bottom of the screen.

#### Layout

- **Background:** Beige strip (#f8f8a8)
- **Hearts:** Left-aligned row of heart icons, drawn at 2x scale with 4px spacing
  - Full heart icon when the player has that HP point
  - Empty heart icon when that HP point is depleted
  - Max of 3 hearts displayed
- **Rupee Icon:** Displayed to the right of the hearts, 2.5x scale
- **Rupee Count:** `global.rupees` value shown as text to the right of the rupee icon, 2x text scale, using `fnt_hud`
- **A-Button Slot:** Right side of the bar, shows a frame with an "A" badge and the sword icon inside
- **B-Button Slot:** To the right of A slot (30px gap), shows a frame with a "B" badge and a dark fill (empty, reserved for a second item)
- **Top Border:** A thin dark line along the top edge of the HUD strip

---

### oMoblinCave1 (Environment Sprite)

A decorative background object using the `moblin_cave_1` sprite at 2x scale. No logic, purely visual.

---

## Scripts (Macro Files)

### SpriteMacros.gml

Defines named constants for all player sprite assets:

- Walk: `PLAYER_RIGHT`, `PLAYER_UP`, `PLAYER_LEFT`, `PLAYER_DOWN`
- Idle: `PLAYER_IDLERIGHT`, `PLAYER_IDLEUP`, `PLAYER_IDLELEFT`, `PLAYER_IDLEDOWN`
- Stab: `PLAYER_STAB_RIGHT`, `PLAYER_STAB_UP`, `PLAYER_STAB_LEFT`, `PLAYER_STAB_DOWN`
- Hurt: `PLAYER_HURT_RIGHT`, `PLAYER_HURT_UP`, `PLAYER_HURT_LEFT`, `PLAYER_HURT_DOWN`

### EnemySpriteMacros.gml

Defines named constants for all Moblin sprite assets:

- Walk: `MOBLIN_WALK_RIGHT`, `MOBLIN_WALK_LEFT`, `MOBLIN_WALK_UP`, `MOBLIN_WALK_DOWN`
- Attack: `MOBLIN_ATTACK_RIGHT`, `MOBLIN_ATTACK_LEFT`, `MOBLIN_ATTACK_UP`, `MOBLIN_ATTACK_DOWN`

### MovementMacros.gml

Defines direction constants and input bindings:

**Direction Constants:**

- `RIGHT = 0`, `UP = 1`, `LEFT = 2`, `DOWN = 3`
- `IDLERIGHT = 4`, `IDLEUP = 5`, `IDLELEFT = 6`, `IDLEDOWN = 7`

**Speed Constants:**

- `WALKSPEED = 2`
- `RUNSPEED = 3`

**Input Bindings:**

- Attack: Z key or Gamepad Face Button 1 (A)
- Movement: Arrow keys or WASD
- Run: Shift or Gamepad Face Button 2 (B)
- Analog stick: supported with deadzone and normalization

---

## Global Systems

### Hitpause

When the player's attack connects with an enemy, `global.hitpause` is set to 4. Every object's Step event checks this value at the top and returns early if it is above 0, then decrements it. This creates a brief freeze-frame on impact that adds weight and feedback to hits.

### Rupees

`global.rupees` is initialized to 0 and displayed on the HUD. The pickup and collection logic is not yet implemented but the counter and display are fully ready.

### Player Movement Lock

`global.player_can_move` is a boolean initialized to `true`. Setting it to `false` prevents the player from receiving movement input. This is the foundation for cutscene control or scripted sequences.

---

## Sprite Assets

### Player Sprites (16 total)

- 4 walk direction sprites
- 4 idle direction sprites
- 4 stab attack direction sprites
- 4 hurt direction sprites

### Moblin Sprites (8 total)

- 4 walk direction sprites
- 4 attack direction sprites

### HUD Sprites (7 total)

- `s_hud_heart_full`, `s_hud_heart_empty`, `s_hud_heart_half`
- `s_hud_button_a`, `s_hud_button_b`
- `s_hud_sword`, `s_hud_rupee`, `s_hud_slot_frame`

### Environment Sprites

- `spr_wall`: collision tile
- `moblin_cave`, `moblin_cave_1`: background art
- `spr_warp_block`: warp trigger visual

---

## Fonts

- **fnt_hud:** Used for all HUD text (rupee counter, stat displays)
- **fnt_dialogue:** Declared and ready; no active dialogue system yet

---

## Sounds

- **snd_typewriter:** One sound asset present in the project, currently unused

---

## Player Stats Summary

| Stat                     | Value      |
| ------------------------ | ---------- |
| Max HP                   | 3 hearts   |
| Walk Speed               | 2 px/frame |
| Run Speed                | 3 px/frame |
| Acceleration             | 0.4        |
| Deceleration             | 1.0        |
| Attack Duration          | 14 frames  |
| Hitbox Spawn Frame       | Frame 4    |
| Hurt Duration            | 20 frames  |
| Invulnerability Duration | 40 frames  |

---

## Implementation Status

### Complete and Functional

- Player movement: walk, run, 8-directional animation with idle states
- Keyboard and gamepad input (simultaneous support)
- Smooth acceleration and deceleration physics
- Wall collision detection
- Depth sorting (y-sort)
- 4-directional attack with direction-aware hitbox
- Hitpause freeze-frame on combat impact
- Enemy damage and knockback from player attacks
- Player damage from enemy attacks
- Player hurt state with flashing animation
- Invulnerability i-frames
- Moblin patrol AI with fixed patrol points
- Moblin alert state with visual flash
- Moblin chase AI with leash radius and 4-directional snapping
- Moblin melee attack with timed hit frame
- Moblin stagger with directional knockback and wall collision
- Moblin death fade-out animation
- HUD: heart display, rupee counter, item slot frames
- Room transition system (warp block and warp animation)
- Global game state manager

### Infrastructure Ready, Not Yet Active

- B-button item slot (frame and badge drawn, no item assigned)
- Dialogue font (`fnt_dialogue`) declared
- `global.rupees` counter and HUD display (no pickup logic yet)
- `global.player_can_move` flag (no cutscene system consuming it yet)
- `VestiOffice` room (warp block configured, room itself not built out)

### Not Yet Implemented

- Projectile weapons
- Ranged or magic systems
- Chest and item pickup
- Additional enemy types
- Boss enemies
- Dungeon design
- Puzzles (pushable blocks, switches, etc.)
- Sound effects and music
- Dialogue and text box system
- Save and load system
- Menus and title screen
- Inventory system
