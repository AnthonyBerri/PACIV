var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

hovered = -1;
var _pick = -1;

for (var i = 0; i < array_length(options); i++) {
	var _cx = start_x + (i * card_gap);
	if (_mx >= _cx && _mx <= _cx + card_w && _my >= card_y && _my <= card_y + card_h) {
		hovered = i;
		if (mouse_check_button_pressed(mb_left)) {
			_pick = i;
		}
	}
}

if (keyboard_check_pressed(ord("1")) && array_length(options) >= 1) _pick = 0;
if (keyboard_check_pressed(ord("2")) && array_length(options) >= 2) _pick = 1;
if (keyboard_check_pressed(ord("3")) && array_length(options) >= 3) _pick = 2;

if (_pick != -1) {
	ApplyRewardOption(options[_pick]);
	global.week_pending_reward = false;
	global.deliveries_this_week = 0;
	global.game_paused = false;
	instance_destroy();
}
