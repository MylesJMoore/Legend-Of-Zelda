//Debug visualization — remove or wrap in a debug flag later
draw_set_color(c_red);
draw_set_alpha(0.4);
draw_rectangle(x - hb_width/2, y - hb_height/2, x + hb_width/2, y + hb_height/2, false);
draw_set_alpha(1);