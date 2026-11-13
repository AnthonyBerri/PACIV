#macro TILE_SIZE 8
#macro GRID_W 40 // 320 / 8
#macro GRID_H 22 // 176 / 8 (deixa 4px de margem inferior em 180px)

function GridInit() {
	global.grid = array_create(GRID_W);
	for (var _x = 0; _x < GRID_W; _x++) {
		global.grid[_x] = array_create(GRID_H);
		for (var _y = 0; _y < GRID_H; _y++) {
			global.grid[_x][_y] = {
				rail: noone,
				station: noone,
				blocked: false
			};
		}
	}
}

function WorldToGridX(_wx) {
	return floor(_wx / TILE_SIZE);
}

function WorldToGridY(_wy) {
	return floor(_wy / TILE_SIZE);
}

function GridToWorldX(_gx) {
	return _gx * TILE_SIZE;
}

function GridToWorldY(_gy) {
	return _gy * TILE_SIZE;
}

function GridInBounds(_gx, _gy) {
	return (_gx >= 0 && _gx < GRID_W && _gy >= 0 && _gy < GRID_H);
}

function GridGetCell(_gx, _gy) {
	if (!GridInBounds(_gx, _gy)) {
		return undefined;
	}
	return global.grid[_gx][_gy];
}

