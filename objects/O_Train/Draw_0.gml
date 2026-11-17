draw_self();

if (variable_global_exists("debug_overlay") && global.debug_overlay) {
	draw_set_halign(fa_center);
	var _dbg = state + " (" + string(route_index) + "/" + string(array_length(route)) + ")";
	draw_text_transformed_color(x, y - 12, _dbg, 0.35, 0.35, 0, c_yellow, c_yellow, c_yellow, c_yellow, 1);
	draw_set_halign(fa_left);
}
