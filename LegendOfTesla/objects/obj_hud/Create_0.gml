//-------------------------------------------
// HUD Bar
//-------------------------------------------
bar_height = 48;
bar_color  = make_color_rgb(248, 248, 168);

//Hearts
heart_size            = 16;
heart_scale           = 2;
heart_spacing         = 4;
heart_start_x         = 12;
heart_start_y_padding = 6;

//Rupee
rupee_x            = 150;
rupee_icon_padding = -5;
rupee_icon_scale   = 2.5;
rupee_text_scale   = 2;

//A/B slots
slot_size  = 24;
slot_scale = 2;

//Slot gap — space between A and B frames
slot_gap = 30;

//Letter padding — shared baseline
letter_padding_x = 2;
letter_padding_y = 0;

//Individual letter padding — fine-tune each letter independently
letter_a_padding_x = -15;  // added ON TOP of letter_padding_x for A only
letter_a_padding_y = 0;  // added ON TOP of letter_padding_y for A only
letter_b_padding_x = -15;  // added ON TOP of letter_padding_x for B only
letter_b_padding_y = 0;  // added ON TOP of letter_padding_y for B only

//Individual icon padding — fine-tune icon position within each slot
icon_a_padding_x = -10;
icon_a_padding_y = 0;
icon_b_padding_x = 0;  // unused since B is empty, but ready for when it's filled
icon_b_padding_y = 0;

//Slot frame right margin — distance from right edge of screen
slot_right_margin = 8;