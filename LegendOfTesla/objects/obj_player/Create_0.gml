//Player Variables
global.hitpause = 0; // shared freeze-frame timer
ACCEL = 0.4;  // how quickly you reach top speed — lower = more "weight"
DECEL = 1.0;  // how quickly you stop — lower = more slide
xspeed = 0;
yspeed = 0;
move_speed = 1;

//Player Adult Sprites with Macros
sprite[RIGHT] = PLAYER_RIGHT;
sprite[UP] = PLAYER_UP;
sprite[LEFT] = PLAYER_LEFT;
sprite[DOWN] = PLAYER_DOWN;
sprite[IDLERIGHT] = PLAYER_IDLERIGHT;
sprite[IDLEUP] = PLAYER_IDLEUP;
sprite[IDLELEFT] = PLAYER_IDLELEFT;
sprite[IDLEDOWN] = PLAYER_IDLEDOWN;
face = DOWN;

//Player Sprite Direction Information
sprite_information[RIGHT] = "Right";
sprite_information[UP] = "Up";
sprite_information[LEFT] = "Left";
sprite_information[DOWN] = "Down";
sprite_information[IDLERIGHT] = "Right";
sprite_information[IDLEUP] = "Up";
sprite_information[IDLELEFT] = "Left";
sprite_information[IDLEDOWN] = "Down";
current_direction = "Down";

#region Combat — Build 1

//Player States
enum PLAYER_STATE {
    IDLE,
    WALK,
    ATTACK,
    HURT
}
state = PLAYER_STATE.IDLE;

//Stab sprites — indexed by base direction (RIGHT/UP/LEFT/DOWN macros)
sprite_stab[RIGHT] = PLAYER_STAB_RIGHT;
sprite_stab[UP]    = PLAYER_STAB_UP;
sprite_stab[LEFT]  = PLAYER_STAB_LEFT;
sprite_stab[DOWN]  = PLAYER_STAB_DOWN;

//Hurt sprites — indexed by base direction
sprite_hurt[RIGHT] = PLAYER_HURT_RIGHT;
sprite_hurt[UP]    = PLAYER_HURT_UP;
sprite_hurt[LEFT]  = PLAYER_HURT_LEFT;
sprite_hurt[DOWN]  = PLAYER_HURT_DOWN;

//Tracks last non-idle direction — used for stab aim + hitbox offset
facing_dir = DOWN;

//Attack tuning
attack_timer = 0;
ATTACK_DURATION = 14;     // total frames stab state lasts — tune for weight
HITBOX_SPAWN_FRAME = 4;   // frame within attack where hitbox appears (anticipation)
hitbox_spawned = false;

//Hurt/HP
hp = 3;
hurt_timer = 0;
HURT_DURATION = 20;
invuln_timer = 0;
INVULN_DURATION = 40;

#endregion