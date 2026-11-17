if (keyboard_check_pressed(vk_f3)) {
	global.debug_overlay = !global.debug_overlay;
}

if (global.game_over || global.week_pending_reward) {
	exit;
}

// Atalho de Pausa com Espaco
if (keyboard_check_pressed(vk_space)) {
	global.game_paused = !global.game_paused;
}

// Cliques nos botoes de velocidade no HUD superior (y: 2..13)
if (mouse_check_button_pressed(mb_left)) {
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);
	if (_my >= 2 && _my <= 13) {
		if (_mx >= 128 && _mx <= 146) {
			global.game_paused = !global.game_paused;
		} else if (_mx >= 150 && _mx <= 168) {
			global.game_paused = false;
			global.game_speed = 1;
		} else if (_mx >= 172 && _mx <= 190) {
			global.game_paused = false;
			global.game_speed = 2;
		}
	}
}

TimeUpdate(delta_time / 1000000);
