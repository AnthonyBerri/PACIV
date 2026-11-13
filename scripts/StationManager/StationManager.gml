enum LINE_COLOR {
	RED = 0,
	BLUE = 1,
	YELLOW = 2,
	GREEN = 3
}

function GetLineColorValue(_color_id) {
	switch (_color_id) {
		case LINE_COLOR.RED:    return make_color_rgb(230, 65, 65);
		case LINE_COLOR.BLUE:   return make_color_rgb(65, 145, 255);
		case LINE_COLOR.YELLOW: return make_color_rgb(250, 210, 55);
		case LINE_COLOR.GREEN:  return make_color_rgb(70, 205, 110);
	}
	return c_white;
}

function GetLineColorName(_color_id) {
	switch (_color_id) {
		case LINE_COLOR.RED:    return "VERMELHA";
		case LINE_COLOR.BLUE:   return "AZUL";
		case LINE_COLOR.YELLOW: return "AMARELA";
		case LINE_COLOR.GREEN:  return "VERDE";
	}
	return "";
}

function CanPlaceStationAt(_gx, _gy, _w, _h, _entry_gx, _entry_gy) {
	// Margem para caber na tela e nao colidir com o HUD inferior (gy < 19)
	if (_gx < 1 || _gy < 2 || _gx + _w > GRID_W - 1 || _gy + _h > GRID_H - 3) {
		return false;
	}
	if (!GridInBounds(_entry_gx, _entry_gy)) {
		return false;
	}

	for (var _ix = _gx; _ix < _gx + _w; _ix++) {
		for (var _iy = _gy; _iy < _gy + _h; _iy++) {
			var _c = GridGetCell(_ix, _iy);
			if (_c == undefined || _c.blocked || _c.station != noone || _c.rail != noone) {
				return false;
			}
		}
	}

	var _ec = GridGetCell(_entry_gx, _entry_gy);
	if (_ec == undefined || _ec.blocked || _ec.station != noone) {
		return false;
	}

	// Distancia minima de outras estacoes
	with (O_Station) {
		var _dist = point_distance(_gx, _gy, gx, gy);
		if (_dist < 7) {
			return false;
		}
	}

	return true;
}

function CreateStation(_gx, _gy, _role, _color) {
	var _w = (_role == "depot") ? 2 : 4;
	var _h = (_role == "depot") ? 2 : 4;
	var _entry_gx = _gx + floor(_w * 0.5);
	var _entry_gy = _gy + _h;

	var _cx = GridToWorldX(_gx) + (_w * TILE_SIZE * 0.5);
	var _cy = GridToWorldY(_gy) + (_h * TILE_SIZE * 0.5);

	var _st = instance_create_layer(_cx, _cy, "Instances", O_Station);
	_st.station_role = _role;
	_st.line_color = _color;
	_st.gx = _gx;
	_st.gy = _gy;
	_st.w_tiles = _w;
	_st.h_tiles = _h;
	_st.entry_gx = _entry_gx;
	_st.entry_gy = _entry_gy;

	// Marca celulas ocupadas no grid como bloqueadas para trilhos
	for (var _ix = _gx; _ix < _gx + _w; _ix++) {
		for (var _iy = _gy; _iy < _gy + _h; _iy++) {
			var _cell = GridGetCell(_ix, _iy);
			if (_cell != undefined) {
				_cell.station = _st;
				_cell.blocked = true;
			}
		}
	}

	// Se for deposito, spawna o trem inicial estacionado na entrada
	if (_role == "depot") {
		SpawnTrainForDepot(_st);
	}

	return _st;
}

function SpawnTrainForDepot(_depot) {
	var _tx = GridToWorldX(_depot.entry_gx) + (TILE_SIZE * 0.5);
	var _ty = GridToWorldY(_depot.entry_gy) + (TILE_SIZE * 0.5);
	var _train = instance_create_layer(_tx, _ty, "Trains", O_Train);
	_train.home_depot = _depot;
	_train.line_color = _depot.line_color;
	_train.image_blend = GetLineColorValue(_depot.line_color);
	array_push(_depot.trains, _train);
	return _train;
}

function TrySpawnNewStation(_role, _color) {
	var _w = (_role == "depot") ? 2 : 4;
	var _h = (_role == "depot") ? 2 : 4;

	for (var _try = 0; _try < 60; _try++) {
		var _gx = irandom_range(2, GRID_W - _w - 2);
		var _gy = irandom_range(2, GRID_H - _h - 4);
		var _entry_gx = _gx + floor(_w * 0.5);
		var _entry_gy = _gy + _h;

		if (CanPlaceStationAt(_gx, _gy, _w, _h, _entry_gx, _entry_gy)) {
			return CreateStation(_gx, _gy, _role, _color);
		}
	}
	return noone;
}

function SpawnInitialStations() {
	// 1 Deposito (origem de trens) e 1 Destino (requerimentos) da cor Vermelha
	CreateStation(5, 8, "depot", LINE_COLOR.RED);
	CreateStation(28, 7, "destination", LINE_COLOR.RED);
}

