//-------------------------------------------
// LAYOUT — calculated fresh each frame
//-------------------------------------------
var bar_y         = display_get_gui_height() - bar_height;
var heart_start_y = bar_y + (bar_height/2) - ((heart_size * heart_scale)/2);
var rupee_y       = bar_y + (bar_height/2) - ((sprite_get_height(s_hud_rupee) * rupee_icon_scale)/2);

//Slot layout
var frame_w            = 28 * slot_scale;
var frame_h            = 16 * slot_scale;
var slot_y             = bar_y + (bar_height/2) - (frame_h/2);
var letter_zone_w      = 10 * slot_scale;
var icon_zone_x_offset = letter_zone_w + (((28 - 10) * slot_scale) / 2);

//Right-anchored slots
var slot_a_x = display_get_gui_width() - frame_w - slot_right_margin;
var slot_b_x = slot_a_x - frame_w - slot_gap;

//Letter positions — shared padding + individual padding combined
var letter_a_x        = slot_a_x + letter_padding_x + letter_a_padding_x;
var letter_a_y_offset = (frame_h/2) + letter_padding_y + letter_a_padding_y;

var letter_b_x        = slot_b_x + letter_padding_x + letter_b_padding_x;
var letter_b_y_offset = (frame_h/2) + letter_padding_y + letter_b_padding_y;

//Icon positions — icon zone center + individual padding
var icon_a_x = slot_a_x + icon_zone_x_offset + icon_a_padding_x;
var icon_a_y = slot_y + (frame_h/2) + icon_a_padding_y;

var icon_b_x = slot_b_x + icon_zone_x_offset + icon_b_padding_x;
var icon_b_y = slot_y + (frame_h/2) + icon_b_padding_y;

//-------------------------------------------
// STATUS BAR BACKGROUND
//-------------------------------------------
draw_set_color(bar_color);
draw_set_alpha(1);
draw_rectangle(0, bar_y, display_get_gui_width(), display_get_gui_height(), false);
draw_set_color(c_white);

//Top border line
draw_set_color(make_color_rgb(80, 80, 80));
draw_line(0, bar_y, display_get_gui_width(), bar_y);
draw_set_color(c_white);

//-------------------------------------------
// HEARTS
//-------------------------------------------
if (instance_exists(obj_player)) {
    var _hp     = obj_player.hp;
    var _max_hp = 3;

    for (var i = 0; i < _max_hp; i++) {
        var _hx = heart_start_x + (i * (heart_size * heart_scale + heart_spacing));
        var _hy = heart_start_y + heart_start_y_padding;

        if (i < _hp) {
            draw_sprite_ext(s_hud_heart_full,  0, _hx, _hy, heart_scale, heart_scale, 0, c_white, 1);
        } else {
            draw_sprite_ext(s_hud_heart_empty, 0, _hx, _hy, heart_scale, heart_scale, 0, c_white, 1);
        }
    }
}

//-------------------------------------------
// RUPEE ICON + COUNT
//-------------------------------------------
draw_sprite_ext(s_hud_rupee, 0, rupee_x + rupee_icon_padding, rupee_y, rupee_icon_scale, rupee_icon_scale, 0, c_white, 1);

var rupee_text_x = rupee_x + (sprite_get_width(s_hud_rupee) * rupee_text_scale) + 6;
var rupee_text_y = rupee_y + ((sprite_get_height(s_hud_rupee) * rupee_text_scale) / 2);

draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_set_font(fnt_hud);
draw_text_transformed(rupee_text_x, rupee_text_y, string(global.rupees), rupee_text_scale, rupee_text_scale, 0);

//-------------------------------------------
// B SLOT
//-------------------------------------------
draw_sprite_ext(s_hud_slot_frame, 0, slot_b_x, slot_y, slot_scale, slot_scale, 0, c_white, 1);

draw_sprite_ext(
    s_hud_button_b, 0,
    letter_b_x,
    slot_y + letter_b_y_offset,
    slot_scale, slot_scale, 0, c_white, 1
);

//B slot empty — subtle dark fill in icon zone
draw_set_color(make_color_rgb(100, 100, 100));
draw_set_alpha(0.4);
draw_rectangle(
    slot_b_x + letter_zone_w + 2, slot_y + 2,
    slot_b_x + frame_w - 2, slot_y + frame_h - 2,
    false
);
draw_set_alpha(1);
draw_set_color(c_white);

//-------------------------------------------
// A SLOT — stab weapon equipped
//-------------------------------------------
draw_sprite_ext(s_hud_slot_frame, 0, slot_a_x, slot_y, slot_scale, slot_scale, 0, c_white, 1);

draw_sprite_ext(
    s_hud_button_a, 0,
    letter_a_x,
    slot_y + letter_a_y_offset,
    slot_scale, slot_scale, 0, c_white, 1
);

draw_sprite_ext(
    s_hud_sword, 0,
    icon_a_x, icon_a_y,
    slot_scale, slot_scale, 0, c_white, 1
);