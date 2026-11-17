var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Botao "JOGAR NOVAMENTE" centralizado (x: 100..220, y: 112..132)
var _btn_hover = (_mx >= 100 && _mx <= 220 && _my >= 112 && _my <= 132);

if (keyboard_check_pressed(vk_enter) || (_btn_hover && mouse_check_button_pressed(mb_left))) {
	room_restart();
}
