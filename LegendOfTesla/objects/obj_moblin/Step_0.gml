//Hitpause — freeze, but don't decrement (player already does)
if (global.hitpause > 0) {
    exit;
}

switch (state) {

    //=========================================
    case ENEMY_STATE.PATROL:
    //=========================================

    //Move toward current patrol target along x axis
    if (x < patrol_target) {
        x += patrol_speed;
        facing_dir = RIGHT;
    } else if (x > patrol_target) {
        x -= patrol_speed;
        facing_dir = LEFT;
    }

    //Reached target — flip to the other point
    if (point_distance(x, y, patrol_target, y) <= patrol_speed) {
        patrol_target = (patrol_target == patrol_point_a) ? patrol_point_b : patrol_point_a;
    }

    sprite_index = sprite_walk[facing_dir];

    //Check aggro
    if (instance_exists(obj_player)) {
        if (point_distance(x, y, obj_player.x, obj_player.y) <= AGGRO_RADIUS) {
            state = ENEMY_STATE.ALERT;
            alert_timer = ALERT_DURATION;
        }
    }

    break;


    //=========================================
    case ENEMY_STATE.ALERT:
    //=========================================

    alert_timer--;

    //Hold still, flash to signal "noticed you"
    image_blend = (alert_timer mod 8 < 4) ? c_white : c_yellow;
    sprite_index = sprite_walk[facing_dir]; // held on current walk frame

    if (alert_timer <= 0) {
        image_blend = c_white;
        state = ENEMY_STATE.CHASE;
    }

    break;


    //=========================================
    case ENEMY_STATE.CHASE:
    //=========================================

    if (instance_exists(obj_player)) {
        var _dist = point_distance(x, y, obj_player.x, obj_player.y);

        //Give up if player is too far — return to patrol
        if (_dist > LEASH_RADIUS) {
            state = ENEMY_STATE.PATROL;
            //Resume patrol toward whichever point is closer
            patrol_target = (point_distance(x, y, patrol_point_a, y) < point_distance(x, y, patrol_point_b, y))
                ? patrol_point_a : patrol_point_b;
            break;
        }

        //Close enough to attack
        if (_dist <= ATTACK_RANGE) {
            state = ENEMY_STATE.ATTACK;
            attack_timer = ATTACK_DURATION;
            attack_hit_done = false;
            sprite_index = sprite_attack[facing_dir];
            image_index = 0;
            break;
        }

        //Otherwise, move toward player
        var _dir = point_direction(x, y, obj_player.x, obj_player.y);

        //Snap to 4-directional facing
        if (_dir >= 45 && _dir < 135) {
            facing_dir = UP;
        } else if (_dir >= 135 && _dir < 225) {
            facing_dir = LEFT;
        } else if (_dir >= 225 && _dir < 315) {
            facing_dir = DOWN;
        } else {
            facing_dir = RIGHT;
        }

        x += lengthdir_x(chase_speed, _dir);
        y += lengthdir_y(chase_speed, _dir);

        sprite_index = sprite_walk[facing_dir];
    } else {
        //Player doesn't exist — return to patrol
        state = ENEMY_STATE.PATROL;
    }

    break;


    //=========================================
    case ENEMY_STATE.ATTACK:
    //=========================================

    attack_timer--;
    sprite_index = sprite_attack[facing_dir];

    //Damage check on a specific frame
    if (!attack_hit_done && attack_timer <= (ATTACK_DURATION - ATTACK_HIT_FRAME)) {
        if (instance_exists(obj_player)) {
            if (point_distance(x, y, obj_player.x, obj_player.y) <= ATTACK_RANGE
                && obj_player.invuln_timer <= 0) {

                obj_player.state = PLAYER_STATE.HURT;
                obj_player.hurt_timer = obj_player.HURT_DURATION;
                obj_player.invuln_timer = obj_player.INVULN_DURATION;
                obj_player.hp -= 1;
            }
        }
        attack_hit_done = true;
    }

    if (attack_timer <= 0) {
        state = ENEMY_STATE.CHASE;
    }

    break;


    //=========================================
    case ENEMY_STATE.STAGGER:
    //=========================================

    stagger_timer--;

	//Knockback — quick pop, then hard stop for the remainder
	if (knockback_timer > 0) {
	    var _kx = lengthdir_x(knockback_speed, knockback_dir);
	    var _ky = lengthdir_y(knockback_speed, knockback_dir);

	    if (!place_meeting(x + _kx, y, obj_wall)) {
	        x += _kx;
	    }
	    if (!place_meeting(x, y + _ky, obj_wall)) {
	        y += _ky;
	    }

	    knockback_timer--;
	}

	//Flash
	image_blend = (stagger_timer mod 4 < 2) ? c_white : c_red;

	if (stagger_timer <= 0) {
	    image_blend = c_white;
	    state = previous_state;
	}

	break;


    //=========================================
    case ENEMY_STATE.DEAD:
    //=========================================

    death_timer--;
    image_alpha -= (1 / DEATH_DURATION);

    if (death_timer <= 0 || image_alpha <= 0) {
        instance_destroy();
    }

    break;

}