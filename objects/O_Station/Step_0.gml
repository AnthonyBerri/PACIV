if (global.game_paused) {
	exit;
}

var _dt = (delta_time / 1000000) * global.game_speed;

if (station_role == "destination") {
	var _slow_mult = (variable_global_exists("perks")) ? global.perks.demand_slow_mult : 1.0;

	if (demand_count < max_demand) {
		overload_timer = max(0, overload_timer - _dt * 0.5);
		demand_timer += _dt * _slow_mult;
		if (demand_timer >= demand_interval) {
			demand_timer -= demand_interval;
			demand_count += 1;
		}
	} else {
		overload_timer += _dt;
		if (overload_timer >= overload_max) {
			TriggerGameOver(id);
		}
	}
} else if (station_role == "depot") {
	// Despacha trens disponiveis para estacoes destino com demanda da mesma cor
	for (var _t = 0; _t < array_length(trains); _t++) {
		var _train = trains[_t];
		if (!instance_exists(_train) || _train.state != "idle") continue;

		// Garante que o trem parado esteja alinhado na entrada do deposito
		_train.x = GridToWorldX(entry_gx) + (TILE_SIZE * 0.5);
		_train.y = GridToWorldY(entry_gy) + (TILE_SIZE * 0.5);

		var _best_dest = noone;
		var _best_score = -1;
		var _my_color = line_color;

		with (O_Station) {
			if (station_role == "destination" && line_color == _my_color && demand_count > 0) {
				var _prio = (overload_timer * 100) + demand_count;
				if (_prio > _best_score) {
					_best_score = _prio;
					_best_dest = id;
				}
			}
		}

		if (_best_dest != noone) {
			var _route = FindRailPath(entry_gx, entry_gy, _best_dest.entry_gx, _best_dest.entry_gy);
			if (_route != undefined && array_length(_route) > 0) {
				global.debug_info = "ROTA OK: " + string(array_length(_route)) + " tiles | train=" + _train.state;
				_train.target_station = _best_dest;
				_train.route = _route;
				_train.route_index = 0;
				_train.state = "to_dest";
			} else {
				var _sc = GridGetCell(entry_gx, entry_gy);
				var _tc = GridGetCell(_best_dest.entry_gx, _best_dest.entry_gy);
				var _s_ok = (_sc != undefined && _sc.rail != noone) ? ("R" + string(_sc.rail.rot)) : "NO";
				var _t_ok = (_tc != undefined && _tc.rail != noone) ? ("R" + string(_tc.rail.rot)) : "NO";
				global.debug_info = "SEM ROTA (" + string(entry_gx) + "," + string(entry_gy) + " " + _s_ok + ") -> (" + string(_best_dest.entry_gx) + "," + string(_best_dest.entry_gy) + " " + _t_ok + ") | last=" + string(global.debug_last_cell);
			}
		} else {
			global.debug_info = "SEM DESTINO COM DEMANDA";
		}
	}
}
