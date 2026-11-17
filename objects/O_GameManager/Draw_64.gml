// Barra superior semitransparente
draw_set_alpha(0.45);
draw_rectangle_color(0, 0, 320, 15, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1);

// Esquerda: Pontuacao
draw_text_transformed_color(6, 3, "PTS: " + string(global.score), 0.55, 0.55, 0, c_white, c_white, c_white, c_white, 1);

// Centro: Controles de velocidade [||] [1x] [2x]
var _btns = [
	{ x1: 128, x2: 146, label: "||", active: global.game_paused },
	{ x1: 150, x2: 168, label: "1x", active: (!global.game_paused && global.game_speed == 1) },
	{ x1: 172, x2: 190, label: "2x", active: (!global.game_paused && global.game_speed == 2) }
];

draw_set_halign(fa_center);
for (var i = 0; i < array_length(_btns); i++) {
	var _b = _btns[i];
	var _bg = _b.active ? make_color_rgb(70, 130, 190) : make_color_rgb(36, 40, 52);
	var _bd = _b.active ? c_white : c_gray;
	draw_rectangle_color(_b.x1, 2, _b.x2, 13, _bg, _bg, _bg, _bg, false);
	draw_rectangle_color(_b.x1, 2, _b.x2, 13, _bd, _bd, _bd, _bd, true);
	draw_text_transformed_color((_b.x1 + _b.x2) * 0.5, 4, _b.label, 0.42, 0.42, 0, c_white, c_white, c_white, c_white, 1);
}
draw_set_halign(fa_left);

// Direita: Semana, Dia e barra de progresso do dia
var _day_str = "SEM " + string(global.current_week) + " - " + global.day_names[global.current_day];
draw_set_halign(fa_right);
draw_text_transformed_color(314, 2, _day_str, 0.5, 0.5, 0, c_white, c_white, c_white, c_white, 1);
draw_set_halign(fa_left);

var _prog = clamp(global.day_timer / DAY_DURATION_SECONDS, 0, 1);
draw_rectangle_color(250, 11, 314, 13, c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
draw_rectangle_color(250, 11, 250 + (64 * _prog), 13, c_aqua, c_aqua, c_aqua, c_aqua, false);
