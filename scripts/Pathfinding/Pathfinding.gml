function FindRailPath(_start_gx, _start_gy, _target_gx, _target_gy) {
	global.debug_last_cell = "bounds/no-rail";
	if (!GridInBounds(_start_gx, _start_gy) || !GridInBounds(_target_gx, _target_gy)) {
		return undefined;
	}

	var _start_cell = GridGetCell(_start_gx, _start_gy);
	var _target_cell = GridGetCell(_target_gx, _target_gy);
	if (_start_cell == undefined || _start_cell.rail == noone) return undefined;
	if (_target_cell == undefined || _target_cell.rail == noone) return undefined;

	if (_start_gx == _target_gx && _start_gy == _target_gy) {
		return [{ gx: _start_gx, gy: _start_gy }];
	}

	var _visited = array_create(GRID_W);
	var _parent = array_create(GRID_W);
	for (var _x = 0; _x < GRID_W; _x++) {
		_visited[_x] = array_create(GRID_H, false);
		_parent[_x] = array_create(GRID_H, undefined);
	}

	// Direcoes: 0=Leste, 1=Norte, 2=Oeste, 3=Sul
	var _dx = [1, 0, -1, 0];
	var _dy = [0, -1, 0, 1];

	var _q = ds_queue_create();
	ds_queue_enqueue(_q, { gx: _start_gx, gy: _start_gy, dir_in: -1 });
	_visited[_start_gx][_start_gy] = true;

	var _found = false;
	global.debug_last_cell = "none";

	while (!ds_queue_empty(_q)) {
		var _cur = ds_queue_dequeue(_q);
		var _cx = _cur.gx;
		var _cy = _cur.gy;
		global.debug_last_cell = string(_cx) + "," + string(_cy);

		if (_cx == _target_gx && _cy == _target_gy) {
			_found = true;
			break;
		}

		var _cell = GridGetCell(_cx, _cy);
		if (_cell == undefined || _cell.rail == noone) continue;

		var _rail = _cell.rail;
		var _ports = GetRailPorts(_rail.rail_type, _rail.rot);

		for (var _d = 0; _d < 4; _d++) {
			// Em cruzamentos, so permite seguir reto no mesmo eixo
			if (_rail.rail_type == RAIL_TYPE.CROSS && _cur.dir_in != -1 && _d != _cur.dir_in) {
				continue;
			}

			var _open = false;
			if (_d == 0) _open = _ports.e;
			else if (_d == 1) _open = _ports.n;
			else if (_d == 2) _open = _ports.w;
			else if (_d == 3) _open = _ports.s;

			if (!_open) continue;

			var _nx = _cx + _dx[_d];
			var _ny = _cy + _dy[_d];
			if (!GridInBounds(_nx, _ny) || _visited[_nx][_ny]) continue;

			var _ncell = GridGetCell(_nx, _ny);
			if (_ncell == undefined || _ncell.rail == noone) continue;

			var _nports = GetRailPorts(_ncell.rail.rail_type, _ncell.rail.rot);
			var _nopen = false;
			if (_d == 0) _nopen = _nports.w;      // Indo para Leste -> vizinho abre Oeste
			else if (_d == 1) _nopen = _nports.s; // Indo para Norte -> vizinho abre Sul
			else if (_d == 2) _nopen = _nports.e; // Indo para Oeste -> vizinho abre Leste
			else if (_d == 3) _nopen = _nports.n; // Indo para Sul -> vizinho abre Norte

			if (!_nopen) continue;

			_visited[_nx][_ny] = true;
			_parent[_nx][_ny] = { gx: _cx, gy: _cy };
			ds_queue_enqueue(_q, { gx: _nx, gy: _ny, dir_in: _d });
		}
	}

	ds_queue_destroy(_q);

	if (!_found) {
		return undefined;
	}

	var _rev = [];
	var _px = _target_gx;
	var _py = _target_gy;
	while (_px != _start_gx || _py != _start_gy) {
		array_push(_rev, { gx: _px, gy: _py });
		var _p = _parent[_px][_py];
		if (_p == undefined) break;
		_px = _p.gx;
		_py = _p.gy;
	}
	array_push(_rev, { gx: _start_gx, gy: _start_gy });

	var _route = [];
	for (var _i = array_length(_rev) - 1; _i >= 0; _i--) {
		array_push(_route, _rev[_i]);
	}

	return _route;
}

