draw_set_alpha(0.82);
draw_rectangle_color(0, 0, 320, 180, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1);

// Caixa central
draw_rectangle_color(60, 32, 260, 144, make_color_rgb(24, 24, 34), make_color_rgb(24, 24, 34), make_color_rgb(24, 24, 34), make_color_rgb(24, 24, 34), false);
draw_rectangle_color(60, 32, 260, 144, c_red, c_red, c_red, c_red, true);

draw_set_halign(fa_center);
draw_text_transformed_color(160, 42, "FIM DE JOGO", 0.85, 0.85, 0, c_red, c_red, c_red, c_red, 1);
draw_text_transformed_color(160, 62, "Uma estacao ficou sobrecarregada!", 0.42, 0.42, 0, c_ltgray, c_ltgray, c_ltgray, c_ltgray, 1);

draw_text_transformed_color(160, 78, "Pontuacao Final: " + string(global.score), 0.55, 0.55, 0, c_white, c_white, c_white, c_white, 1);
draw_text_transformed_color(160, 92, "Semanas Completas: " + string(max(0, global.current_week - 1)), 0.5, 0.5, 0, c_aqua, c_aqua, c_aqua, c_aqua, 1);

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _hov = (_mx >= 100 && _mx <= 220 && _my >= 112 && _my <= 132);
var _btn_bg = _hov ? make_color_rgb(70, 140, 80) : make_color_rgb(45, 95, 55);
var _btn_bd = _hov ? c_lime : c_white;

draw_rectangle_color(100, 112, 220, 132, _btn_bg, _btn_bg, _btn_bg, _btn_bg, false);
draw_rectangle_color(100, 112, 220, 132, _btn_bd, _btn_bd, _btn_bd, _btn_bd, true);
draw_text_transformed_color(160, 117, "REINICIAR [ENTER]", 0.45, 0.45, 0, c_white, c_white, c_white, c_white, 1);

draw_set_halign(fa_left);
