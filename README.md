# Legend of Zelda Prototype

A top-down Zelda-style action prototype built in GameMaker Studio 2 (GML). Runs at 320x240 scaled 3x to 960x720.

---

## Features

### Player

- 8-directional movement with smooth acceleration and deceleration
- Walk and run speeds (Shift / Gamepad B)
- Keyboard (Arrow keys / WASD / Z) and gamepad input supported simultaneously
- 4-directional stab attack with directional hitboxes
- Hurt state with flashing animation and 40-frame invulnerability window
- Y-sorted depth layering

### Combat

- Attack spawns a hitbox on frame 4 of a 14-frame animation
- Hitbox size and offset vary by attack direction
- Hitpause: 4-frame freeze-frame on a successful hit
- Single hit per swing enforced via hit flag

### Moblin Enemy AI (6 states)

- **Patrol:** Moves between two fixed points at 0.6 px/frame
- **Alert:** Stops and flashes yellow for 30 frames when the player enters 64px range
- **Chase:** Pursues at 1.1 px/frame with 4-directional snapping; leashes at 85px
- **Attack:** Deals damage to the player at frame 10 of a 24-frame animation
- **Stagger:** Knocked back for 14 frames with wall collision; flashes red
- **Dead:** Fades out over 20 frames, then self-destructs
- 6 HP per Moblin

### HUD

- Heart display (max 3), updates live from player HP
- Rupee icon and counter (`global.rupees`)
- A-button slot with sword icon; B-button slot ready for a second item

### Room Transitions

- Warp block triggers spawn a warp object that animates and transitions to the target room
- Target room, position, and player facing direction are all configurable per warp block

---

## Controls

| Action | Keyboard          | Gamepad            |
| ------ | ----------------- | ------------------ |
| Move   | Arrow keys / WASD | D-pad / Left stick |
| Run    | Shift             | B button           |
| Attack | Z                 | A button           |

---

## Stats

**Player:** 3 HP, walk 2 px/frame, run 3 px/frame, 40 i-frames on hit

**Moblin:** 6 HP, patrol 0.6 px/frame, chase 1.1 px/frame, aggro at 64px

---

## Built With

GameMaker Studio 2 (GML)
