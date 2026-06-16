//Hitpause — freeze everything for impact frames
if (global.hitpause > 0) {
    global.hitpause--;
    exit;
}

switch (state) {

    //=========================================
    case PLAYER_STATE.IDLE:
    case PLAYER_STATE.WALK:
    //=========================================

    if (global.player_can_move) {
        #region Player Movement

        // Movement Keys
        var right_key = INPUT_RIGHT;
        var left_key  = INPUT_LEFT;
        var up_key    = INPUT_UP;
        var down_key  = INPUT_DOWN;

        // Controller Support for Player Movement
        var axis_x = gamepad_axis_value(0, gp_axislh);
        var axis_y = gamepad_axis_value(0, gp_axislv);

        if (abs(axis_x) > 0.2 || abs(axis_y) > 0.2)
        {
            var magnitude = point_distance(0, 0, axis_x, axis_y);
            var normalized_x = axis_x / magnitude;
            var normalized_y = axis_y / magnitude;

            if (magnitude > 0.2)
            {
                left_key = round(max(-normalized_x, 0));
                right_key = round(max(normalized_x, 0));
                up_key = round(max(-normalized_y, 0));
                down_key = round(max(normalized_y, 0));
            }
        }

        // Player Running
        move_speed = INPUT_RUN_HELD ? RUNSPEED : WALKSPEED;

        // Movement Calculations
        var target_xspeed = (right_key - left_key) * move_speed;
		var target_yspeed = (down_key - up_key) * move_speed;

		xspeed += clamp(target_xspeed - xspeed, -ACCEL, ACCEL);
		yspeed += clamp(target_yspeed - yspeed, -ACCEL, ACCEL);
        #endregion

        #region Player Collision
        if(place_meeting(x + xspeed, y, obj_wall))
        {
            xspeed = 0;
        }

        if(place_meeting(x, y + yspeed, obj_wall))
        {
            yspeed = 0;
        }
        #endregion

        #region Player Animation
        mask_index = sprite[DOWN];

        if(yspeed == 0) {
            if(xspeed > 0) {
                face = RIGHT;
            } 

            if(xspeed < 0) {
                face = LEFT;
            } 
        }

        if(xspeed > 0 && face == LEFT) {
            face = RIGHT;
        } else if(xspeed > 0 && face != LEFT) {
            face = RIGHT;
        }

        if(xspeed < 0 && face == RIGHT) {
            face = LEFT;
        } else if(xspeed < 0 && face != RIGHT) {

        }

        if(xspeed == 0) {
            if(yspeed > 0) {
                face = DOWN;
            } 

            if(yspeed < 0) {
                face = UP;
            }
        }

        if(yspeed > 0 && face == UP) {
            face = DOWN;
        } else if(yspeed > 0 && face != UP) {
            face = DOWN
        }

        if(yspeed < 0 && face == DOWN) {
            face = UP;
        } else if(yspeed < 0 && face != DOWN) {
            face = UP;
        }

        if(xspeed == 0 and yspeed == 0) {
            switch (face)
            {
                case UP:
                    face = IDLEUP;
                break;

                case DOWN:
                    face = IDLEDOWN;
                break;

                case LEFT:
                    face = IDLELEFT;
                break;

                case RIGHT:
                    face = IDLERIGHT;
                break;
            }
        }

        sprite_index = sprite[face];
        current_direction = sprite_information[face];

        switch (face)
        {
            case UP:
                global.player_face_direction = "Up";
            break;

            case DOWN:
                global.player_face_direction = "Down";
            break;

            case LEFT:
                global.player_face_direction = "Left";
            break;

            case RIGHT:
                global.player_face_direction = "Right";
            break;
        }

        //Track facing_dir whenever we have a real (non-idle) direction
        switch (face)
        {
            case UP:
            case DOWN:
            case LEFT:
            case RIGHT:
                facing_dir = face;
            break;
        }

        #endregion

        #region Player Physics
        x += xspeed;
        y += yspeed;
        depth = -bbox_bottom;
        #endregion

        #region Player Duplicate Object Cleanup
        if (instance_number(obj_player) > 1) {
            instance_destroy();
        }
        #endregion

        // Set walk/idle sub-state for clarity
        state = (xspeed != 0 || yspeed != 0) ? PLAYER_STATE.WALK : PLAYER_STATE.IDLE;

        // Attack input check (last thing in this state)
        if (INPUT_ATTACK_PRESSED) {
            state = PLAYER_STATE.ATTACK;
            attack_timer = ATTACK_DURATION;
            hitbox_spawned = false;
            xspeed = 0;
            yspeed = 0;
            sprite_index = sprite_stab[facing_dir];
            image_index = 0;
            image_speed = 1; // adjust to match stab sprite frame count vs ATTACK_DURATION
        }
    }

    break;


    //=========================================
    case PLAYER_STATE.ATTACK:
    //=========================================

    attack_timer--;

    // Spawn hitbox once, on the anticipation frame
    if (!hitbox_spawned && attack_timer <= (ATTACK_DURATION - HITBOX_SPAWN_FRAME)) {
	    var spawn_x = x;
	    var spawn_y = y;
	    var hb_offset = 12;

	    //In player's ATTACK case, replace the single hb_offset with:
		var hb_offset_h = 14;    // horizontal reach (left/right)
		var hb_offset_up = 16;   // increase this from 12 — push UP hitbox further out
		var hb_offset_down = 12; // keep DOWN as-is

		switch (facing_dir) {
		    case RIGHT: spawn_x += hb_offset_h; break;
		    case LEFT:  spawn_x -= hb_offset_h; break;
		    case UP:    spawn_y -= hb_offset_up; break;
		    case DOWN:  spawn_y += hb_offset_down; break;
		}
		
	    var _hb = instance_create_depth(spawn_x, spawn_y, depth, obj_stab_hitbox);
	    _hb.facing_dir = facing_dir;
	    _hb.owner = id;

	    hitbox_spawned = true;
	}

    if (attack_timer <= 0) {
        state = PLAYER_STATE.IDLE;
    }

    break;


    //=========================================
    case PLAYER_STATE.HURT:
    //=========================================

    hurt_timer--;
    sprite_index = sprite_hurt[facing_dir];

    // Simple flash while hurt
    image_blend = (hurt_timer mod 8 < 4) ? c_white : c_red;

    if (hurt_timer <= 0) {
        image_blend = c_white;
        state = PLAYER_STATE.IDLE;
    }

    break;

}

// Invuln timer ticks down regardless of state
if (invuln_timer > 0) {
    invuln_timer--;
}