// Fundo escuro semitransparente
draw_set_alpha(0.78);
draw_rectangle_color(0, 0, 320, 180, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_text_transformed_color(160, 16, "SEMANA CONCLUIDA!", 0.7, 0.7, 0, c_yellow, c_yellow, c_yellow, c_yellow, 1);
draw_text_transformed_color(160, 30, "Entregas na semana: " + string(global.deliveries_this_week) + " | Escolha 1 pacote:", 0.45, 0.45, 0, c_ltgray, c_ltgray, c_ltgray, c_ltgray, 1);

for (var i = 0; i < array_length(options); i++) {
	var _opt = options[i];
	var _cx = start_x + (i * card_gap);
	var _cy = card_y;
	var _is_hov = (hovered == i);
	var _bg = _is_hov ? make_color_rgb(45, 55, 78) : make_color_rgb(28, 32, 46);
	var _bd = _is_hov ? c_yellow : c_gray;

	draw_rectangle_color(_cx, _cy, _cx + card_w, _cy + card_h, _bg, _bg, _bg, _bg, false);
	draw_rectangle_color(_cx, _cy, _cx + card_w, _cy + card_h, _bd, _bd, _bd, _bd, true);

	var _mid_x = _cx + (card_w * 0.5);
	draw_text_transformed_color(_mid_x, _cy + 5, "[" + string(i + 1) + "]", 0.45, 0.45, 0, c_yellow, c_yellow, c_yellow, c_yellow, 1);
	draw_text_transformed_color(_mid_x, _cy + 16, _opt.title, 0.42, 0.42, 0, c_white, c_white, c_white, c_white, 1);

	var _rail_txt = "+" + string(_opt.straight) + " Reto  +" + string(_opt.turn) + " Curva";
	if (_opt.cross > 0) {
		_rail_txt += "\n+" + string(_opt.cross) + " Cruzamento";
	}
	draw_text_transformed_color(_mid_x, _cy + 36, _rail_txt, 0.4, 0.4, 0, c_aqua, c_aqua, c_aqua, c_aqua, 1);
	draw_text_transformed_color(_mid_x, _cy + 62, _opt.desc, 0.38, 0.38, 0, c_lime, c_lime, c_lime, c_lime, 1);
}

draw_set_halign(fa_left);
