//=========================================
// WINDOW SCALE — uncomment ONE block
// Room/Camera stay 320x240 — this only
// changes how big that gets displayed
//=========================================

// --- 2x SCALE (640 x 480) ---
// Good for: smaller displays, more screen real estate for other windows
/*
window_set_size(640, 480);
display_set_gui_size(640, 480);
*/

// --- 3x SCALE (960 x 720) --- [|CURRENT|]
// Good for: standard desktop, balanced size/zoom

window_set_size(960, 720);
display_set_gui_size(960, 720);


// --- 4x SCALE (1280 x 960) --- [|CURRENT|]
// Good for: larger monitors, maximum readability of pixel art
/*
window_set_size(1280, 960);
display_set_gui_size(1280, 960);
*/

window_center();