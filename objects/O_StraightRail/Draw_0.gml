if (rail_type == RAIL_TYPE.CROSS) {
	draw_sprite_ext(S_StraightRail, 0, x, y, 1, 1, 0, c_white, 1);
	draw_sprite_ext(S_StraightRail, 0, x, y, 1, 1, 90, c_white, 1);

	// Indicador visual da cancela quando um eixo esta reservado/ocupado
	if (occupied_axis != "none") {
		var _gate_col = c_red;
		draw_rectangle_color(x - 1, y - 1, x + 1, y + 1, _gate_col, _gate_col, _gate_col, _gate_col, false);
	}
} else {
	draw_self();
}

