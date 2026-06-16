#region Moblin States

enum ENEMY_STATE {
    PATROL,
    ALERT,
    CHASE,
    ATTACK,
    STAGGER,
    DEAD
}
state = ENEMY_STATE.PATROL;
previous_state = ENEMY_STATE.PATROL; // used to return after stagger

#endregion

#region Sprites — indexed by RIGHT/UP/LEFT/DOWN macros (0-3)

sprite_walk[RIGHT] = MOBLIN_WALK_RIGHT;
sprite_walk[UP]    = MOBLIN_WALK_UP;
sprite_walk[LEFT]  = MOBLIN_WALK_LEFT;
sprite_walk[DOWN]  = MOBLIN_WALK_DOWN;

sprite_attack[RIGHT] = MOBLIN_ATTACK_RIGHT;
sprite_attack[UP]    = MOBLIN_ATTACK_UP;
sprite_attack[LEFT]  = MOBLIN_ATTACK_LEFT;
sprite_attack[DOWN]  = MOBLIN_ATTACK_DOWN;

facing_dir = LEFT; // initial facing — patrol will set this

#endregion

#region Patrol

//Default: patrol horizontally between two points relative to spawn.
//Override patrol_point_a/b in the instance's Creation Code for custom paths.
patrol_point_a = x - 32;
patrol_point_b = x + 32;
patrol_target  = patrol_point_b;
patrol_speed   = 0.6;

#endregion

#region Aggro / Chase

AGGRO_RADIUS = 64;   // player within this range -> alert
LEASH_RADIUS = 85;  // player beyond this while chasing -> give up, return to patrol
chase_speed  = 1.1;

#endregion

#region Alert

alert_timer    = 0;
ALERT_DURATION = 30; // frames held still + flashing before chase begins

#endregion

#region Attack

ATTACK_RANGE    = 14;  // distance to player that triggers attack
attack_timer    = 0;
ATTACK_DURATION = 24;  // total frames in attack state
ATTACK_HIT_FRAME = 10; // frame within attack where damage check happens
attack_hit_done  = false;

#endregion

#region Stagger

stagger_timer    = 0;
STAGGER_DURATION = 20;

#endregion

#region Knockback
//Knockback
knockback_dir    = 0;
knockback_timer  = 0;
knockback_speed  = 2;  // pixels moved per frame during knockback
KNOCKBACK_FRAMES = 14;    // how many frames the knockback lasts
#endregion

#region HP / Death

hp = 6;
death_timer    = 0;
DEATH_DURATION = 20;

#endregion

sprite_index = sprite_walk[facing_dir];
image_speed  = 1;
image_blend  = c_white;