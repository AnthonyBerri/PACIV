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
	var _dx = abs(_tx - x);
	var _dy = abs(_ty - y);
	var _axis = (_dx >= _dy) ? "ew" : "ns";
	var _cross = _wp_cell.rail;

	if (_cross.occupied_axis != "none" && _cross.occupied_axis != _axis && _cross.reserved_by != id) {
		// Cancela fechada: espera o outro trem cruzar
		exit;
	}
	_cross.occupied_axis = _axis;
	_cross.reserved_by = id;
}

var _dist = point_distance(x, y, _tx, _ty);
if (_dist > 0.25) {
	image_angle = point_direction(x, y, _tx, _ty);
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
	route_index += 1;

	if (route_index >= array_length(route)) {
		if (state == "to_dest") {
			// Concluiu entrega na estacao destino
			if (instance_exists(target_station) && target_station.demand_count > 0) {
				target_station.demand_count -= 1;
			}
			if (script_exists(asset_get_index("AddDeliveryScore")) && instance_exists(target_station)) {
				AddDeliveryScore(target_station.x, target_station.y);
			}

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
		}
	}
} else {
	var _dir = point_direction(x, y, _tx, _ty);
	x += lengthdir_x(_spd, _dir);
	y += lengthdir_y(_spd, _dir);
}

