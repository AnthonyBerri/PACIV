var _col = GetLineColorValue(line_color);
var _ex = GridToWorldX(entry_gx) + (TILE_SIZE * 0.5);
var _ey = GridToWorldY(entry_gy) + (TILE_SIZE * 0.5);

// Marcador da celula de entrada/conexao ferroviaria
draw_set_alpha(0.75);
draw_rectangle_color(_ex - 3, _ey - 3, _ex + 3, _ey + 3, _col, _col, _col, _col, true);
draw_set_alpha(1);

if (station_role == "depot") {
	// Estacao Origem / Deposito (menor, estilo garagem de trens)
	draw_sprite_ext(S_TrainStation, 0, x, y, 0.5, 0.5, 0, _col, 1);

	// Etiqueta visual para diferenciar de destino
	draw_set_halign(fa_center);
	draw_text_transformed_color(x, y - 13, "DEP", 0.4, 0.4, 0, _col, _col, _col, _col, 1);
	draw_set_halign(fa_left);
} else {
	// Estacao Destino / Empresa (32x32, recebe entregas)
	draw_sprite_ext(S_TrainStation, 0, x, y, 1, 1, 0, _col, 1);

	// Pins de requerimento acima da estacao
	var _pin_spacing = 5;
	var _start_px = x - ((demand_count - 1) * _pin_spacing * 0.5);
	var _py = y - 19;

	for (var i = 0; i < demand_count; i++) {
		var _px = _start_px + (i * _pin_spacing);
		draw_rectangle_color(_px - 2, _py - 2, _px + 2, _py + 2, _col, _col, _col, _col, false);
		draw_rectangle_color(_px - 2, _py - 2, _px + 2, _py + 2, c_white, c_white, c_white, c_white, true);
	}

	// Barra de alerta de sobrecarga quando atingir max_demand
	if (demand_count >= max_demand) {
		var _ratio = clamp(overload_timer / overload_max, 0, 1);
		var _bar_w = 24;
		var _bx = x - (_bar_w * 0.5);
		var _by = y - 26;
		draw_rectangle_color(_bx, _by, _bx + _bar_w, _by + 3, c_black, c_black, c_black, c_black, false);
		draw_rectangle_color(_bx, _by, _bx + (_bar_w * _ratio), _by + 3, c_red, c_red, c_red, c_red, false);
		draw_rectangle_color(_bx, _by, _bx + _bar_w, _by + 3, c_white, c_white, c_white, c_white, true);
	}
}

