global.rails = [];

function GetRailPorts(_type, _rot) {
	var _r = ((_rot % 4) + 4) % 4;
	if (_type == RAIL_TYPE.STRAIGHT) {
		return (_r % 2 == 0)
			? { n: true,  e: false, s: true,  w: false }  // 0 ou 2 = vertical (N, S)
			: { n: false, e: true,  s: false, w: true  }; // 1 ou 3 = horizontal (E, W)
	}
	if (_type == RAIL_TYPE.TURN) {
		switch (_r) {
			case 0: return { n: false, e: true,  s: true,  w: false }; // Sul <-> Leste
			case 1: return { n: true,  e: true,  s: false, w: false }; // Leste <-> Norte
			case 2: return { n: true,  e: false, s: false, w: true  }; // Norte <-> Oeste
			case 3: return { n: false, e: false, s: true,  w: true  }; // Oeste <-> Sul
		}
	}
	if (_type == RAIL_TYPE.CROSS) {
		return { n: true, e: true, s: true, w: true };
	}
	return { n: false, e: false, s: false, w: false };
}

function CanPlaceRail(_gx, _gy, _type) {
	var _cell = GridGetCell(_gx, _gy);
	if (_cell == undefined || _cell.rail != noone || _cell.station != noone || _cell.blocked) {
		return false;
	}
	return InventoryHasStock(O_Inventory, _type);
}

function PlaceRail(_gx, _gy, _rot, _type) {
	if (!CanPlaceRail(_gx, _gy, _type)) {
		return noone;
	}
	if (!InventoryConsume(O_Inventory, _type)) {
		return noone;
	}

	var _wx = GridToWorldX(_gx) + (TILE_SIZE * 0.5);
	var _wy = GridToWorldY(_gy) + (TILE_SIZE * 0.5);
	var _rail = instance_create_layer(_wx, _wy, "Instances", O_StraightRail);

	_rail.rail_type = _type;
	_rail.rot = ((_rot % 4) + 4) % 4;
	_rail.gx = _gx;
	_rail.gy = _gy;
	_rail.type = _type;
	_rail.sprite_index = (_type == RAIL_TYPE.TURN) ? S_TurnRail : S_StraightRail;
	_rail.image_angle = (_type == RAIL_TYPE.CROSS) ? 0 : (90 * _rail.rot);

	global.grid[_gx][_gy].rail = _rail;
	array_push(global.rails, _rail);
	return _rail;
}

function RemoveRail(_gx, _gy) {
	var _cell = GridGetCell(_gx, _gy);
	if (_cell == undefined || _cell.rail == noone) {
		return false;
	}

	var _rail = _cell.rail;
	InventoryRefund(O_Inventory, _rail.rail_type);
	_cell.rail = noone;

	var _index = array_get_index(global.rails, _rail);
	if (_index != -1) {
		array_delete(global.rails, _index, 1);
	}
	instance_destroy(_rail);
	return true;
}

function PlaceTrain(rx, ry, rrot, rt) {
	if (rrot == 1) {
		rx -= 5;
	}
	var _train = instance_create_layer(rx, ry - 5, "Trains", O_Train);
	_train.image_angle = 90 * rrot;
	return _train;
}
