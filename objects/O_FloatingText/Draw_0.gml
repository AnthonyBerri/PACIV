var _alpha = clamp(1 - (life / max_life), 0, 1);
draw_set_halign(fa_center);
draw_text_transformed_color(x, y, text, 0.5, 0.5, 0, color, color, color, color, _alpha);
draw_set_halign(fa_left);
