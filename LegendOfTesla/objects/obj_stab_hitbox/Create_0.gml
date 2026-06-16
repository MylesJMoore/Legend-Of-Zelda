//Impact Feel
hit_done = false; // ensures one hit per swing
HITPAUSE_FRAMES = 4; // tune this — the "impact" feel

//Lives for a short window, then self-destructs
lifetime = 6; // frames — tune alongside ATTACK_DURATION/HITBOX_SPAWN_FRAME
facing_dir = DOWN; // overwritten by player on spawn
owner = noone;

//No sprite needed — keep invisible, or use a faint debug sprite while tuning
visible = true; // flip to true with a placeholder sprite while testing
sprite_index = -1;

//Default — will be overwritten based on facing_dir below
sized = false; 
hb_width = 16;
hb_height = 16;