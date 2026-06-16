//Lifetime Counter
lifetime--;
if (lifetime <= 0) {
    instance_destroy();
}

//Hitbox Size
if (!sized) {
    switch (facing_dir) {
        case LEFT:
        case RIGHT:
            hb_width = 16; hb_height = 10;
        break;
        case UP:
        case DOWN:
            hb_width = 10; hb_height = 16;
        break;
    }
    sized = true;
}

//Check for enemy hit
if (!hit_done) {
    var _enemy = collision_rectangle(
        x - hb_width/2, y - hb_height/2,
        x + hb_width/2, y + hb_height/2,
        obj_moblin, false, true
    );

    if (_enemy != noone) {
        with (_enemy) {
            if (state != ENEMY_STATE.STAGGER && state != ENEMY_STATE.DEAD) {

                hp -= 1;

                if (hp <= 0) {
                    state = ENEMY_STATE.DEAD;
                    death_timer = DEATH_DURATION;
                } else {
                    previous_state = ENEMY_STATE.CHASE;
                    state = ENEMY_STATE.STAGGER;
                    stagger_timer = STAGGER_DURATION;

                    //Knockback away from the direction player attacked
                    switch (other.facing_dir) {
                        case RIGHT: knockback_dir = 0;   break;
                        case UP:    knockback_dir = 90;  break;
                        case LEFT:  knockback_dir = 180; break;
                        case DOWN:  knockback_dir = 270; break;
                    }
                    knockback_timer = KNOCKBACK_FRAMES;
                }
            }
        }

        global.hitpause = HITPAUSE_FRAMES;
        hit_done = true;
    }
}