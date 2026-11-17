if (global.game_paused || state == "idle" || array_length(route) == 0) {
	exit;
}

var _dt = (delta_time / 1000000) * global.game_speed;
var _speed_mult = (variable_global_exists("perks")) ? global.perks.train_speed_mult : 1.0;
var _spd = base_speed * _speed_mult * _dt;

var _wp = route[route_index];
var _wp_cell = GridGetCell(_wp.gx, _wp.gy);

// Se o trilho do proximo waypoint foi removido, aguarda reconexao
if (_wp_cell == undefined || _wp_cell.rail == noone) {
	exit;
}

var _tx = GridToWorldX(_wp.gx) + (TILE_SIZE * 0.5);
var _ty = GridToWorldY(_wp.gy) + (TILE_SIZE * 0.5);

// Logica de cancela para cruzamentos (RAIL_TYPE.CROSS)
if (_wp_cell.rail.rail_type == RAIL_TYPE.CROSS) {
	var _cross = _wp_cell.rail;
	// Libera reserva fantasma se o trem que reservou ficou idle ou foi destruido
	if (_cross.reserved_by != noone && (!instance_exists(_cross.reserved_by) || _cross.reserved_by.state == "idle")) {
		_cross.occupied_axis = "none";
		_cross.reserved_by = noone;
	}

	var _dx = abs(_tx - x);
	var _dy = abs(_ty - y);
	var _axis = (_dx >= _dy) ? "ew" : "ns";

	if (_cross.occupied_axis != "none" && _cross.occupied_axis != _axis && _cross.reserved_by != id) {
		// Cancela fechada: espera o outro trem cruzar
		exit;
	}
	_cross.occupied_axis = _axis;
	_cross.reserved_by = id;
}

var _dist = point_distance(x, y, _tx, _ty);
if (_dist > 0.25) {
	var _dx_move = _tx - x;
	var _dy_move = _ty - y;
	if (abs(_dx_move) >= abs(_dy_move)) {
		image_angle = 0;
		image_xscale = (_dx_move >= 0) ? 1 : -1;
		image_yscale = 1;
	} else {
		image_angle = (_dy_move < 0) ? 90 : 270;
		image_xscale = 1;
		image_yscale = 1;
	}
}

if (_dist <= _spd) {
	// Libera cancela do tile anterior se era cruzamento
	if (route_index > 0) {
		var _prev_wp = route[route_index - 1];
		var _prev_cell = GridGetCell(_prev_wp.gx, _prev_wp.gy);
		if (_prev_cell != undefined && _prev_cell.rail != noone && _prev_cell.rail.rail_type == RAIL_TYPE.CROSS) {
			if (_prev_cell.rail.reserved_by == id) {
				_prev_cell.rail.occupied_axis = "none";
				_prev_cell.rail.reserved_by = noone;
			}
		}
	}

	x = _tx;
	y = _ty;

	// Entrega em qualquer estacao destino da mesma cor ao passar pela entrada dela durante a ida
	if (state == "to_dest") {
		var _my_color = line_color;
		var _wpx = _wp.gx;
		var _wpy = _wp.gy;
		with (O_Station) {
			if (station_role == "destination" && line_color == _my_color && demand_count > 0) {
				if (entry_gx == _wpx && entry_gy == _wpy) {
					demand_count -= 1;
					AddDeliveryScore(x, y);
				}
			}
		}
	}

	route_index += 1;

	if (route_index >= array_length(route)) {
		// Garante liberacao de cancela se o ultimo tile da rota era um cruzamento
		if (_wp_cell.rail.rail_type == RAIL_TYPE.CROSS && _wp_cell.rail.reserved_by == id) {
			_wp_cell.rail.occupied_axis = "none";
			_wp_cell.rail.reserved_by = noone;
		}

		if (state == "to_dest") {
			// Inverte a rota para retornar ao deposito
			var _ret_route = [];
			for (var _i = array_length(route) - 1; _i >= 0; _i--) {
				array_push(_ret_route, route[_i]);
			}
			route = _ret_route;
			route_index = 0;
			state = "to_depot";
		} else if (state == "to_depot") {
			state = "idle";
			target_station = noone;
			route = [];
			route_index = 0;
			image_angle = 0;
			image_xscale = 1;
			image_yscale = 1;
		}
	}
} else {
	var _dir = point_direction(x, y, _tx, _ty);
	x += lengthdir_x(_spd, _dir);
	y += lengthdir_y(_spd, _dir);
}
