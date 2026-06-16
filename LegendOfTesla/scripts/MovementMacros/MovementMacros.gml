//-------------------------------------------
//Player Movement
//-------------------------------------------
#macro RIGHT 0
#macro UP 1
#macro LEFT 2
#macro DOWN 3
#macro IDLERIGHT 4
#macro IDLEUP 5
#macro IDLELEFT 6
#macro IDLEDOWN 7
#macro WALKSPEED 2
#macro RUNSPEED 3

//-------------------------------------------
//Player Inputs
//-------------------------------------------
#macro ATTACK_KEY ord("Z")

#macro INPUT_RIGHT (keyboard_check(vk_right) || keyboard_check(ord("D")))
#macro INPUT_LEFT  (keyboard_check(vk_left)  || keyboard_check(ord("A")))
#macro INPUT_UP    (keyboard_check(vk_up)    || keyboard_check(ord("W")))
#macro INPUT_DOWN  (keyboard_check(vk_down)  || keyboard_check(ord("S")))

#macro INPUT_RUN_HELD    (keyboard_check(vk_shift) || gamepad_button_check(0, gp_face2))
#macro INPUT_ATTACK_PRESSED (keyboard_check_pressed(ATTACK_KEY) || gamepad_button_check_pressed(0, gp_face1))