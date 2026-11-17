function PerkInit() {
	global.perks = {
		train_speed_mult: 1.0,
		cross_unlocked: false,
		demand_slow_mult: 1.0
	};
}

function GetRewardPool() {
	return [
		{
			perk_id: "speed",
			title: "Locomotiva Expressa",
			desc: "+25% velocidade dos trens",
			straight: 12,
			turn: 6,
			cross: 0
		},
		{
			perk_id: "cross",
			title: "Cruzamento + Cancela",
			desc: "Libera trilho em cruz",
			straight: 8,
			turn: 4,
			cross: 4
		},
		{
			perk_id: "extra_train",
			title: "Trem Adicional",
			desc: "+1 trem em um deposito",
			straight: 10,
			turn: 6,
			cross: 0
		},
		{
			perk_id: "rails",
			title: "Logistica Reforcada",
			desc: "Pacote extra de trilhos",
			straight: 20,
			turn: 10,
			cross: 0
		},
		{
			perk_id: "slow_demand",
			title: "Estacao Otimizada",
			desc: "-15% ritmo de pedidos",
			straight: 10,
			turn: 6,
			cross: 0
		}
	];
}

function RollRewardOptions(_count) {
	var _pool = GetRewardPool();
	var _len = array_length(_pool);

	// Embaralha Fisher-Yates
	for (var i = _len - 1; i > 0; i--) {
		var _j = irandom(i);
		var _tmp = _pool[i];
		_pool[i] = _pool[_j];
		_pool[_j] = _tmp;
	}

	var _res = [];
	var _n = min(_count, _len);
	for (var k = 0; k < _n; k++) {
		array_push(_res, _pool[k]);
	}
	return _res;
}

function ApplyRewardOption(_opt) {
	if (instance_exists(O_Inventory)) {
		var _s0 = InventoryFindSlot(O_Inventory, RAIL_TYPE.STRAIGHT);
		if (_s0 != undefined) _s0.count += _opt.straight;

		var _s1 = InventoryFindSlot(O_Inventory, RAIL_TYPE.TURN);
		if (_s1 != undefined) _s1.count += _opt.turn;

		if (_opt.cross > 0) {
			var _s2 = InventoryFindSlot(O_Inventory, RAIL_TYPE.CROSS);
			if (_s2 != undefined) {
				_s2.unlocked = true;
				_s2.count += _opt.cross;
			}
		}
	}

	switch (_opt.perk_id) {
		case "speed":
			global.perks.train_speed_mult += 0.25;
			break;
		case "cross":
			global.perks.cross_unlocked = true;
			if (instance_exists(O_Inventory)) {
				var _sc = InventoryFindSlot(O_Inventory, RAIL_TYPE.CROSS);
				if (_sc != undefined) _sc.unlocked = true;
			}
			break;
		case "extra_train":
			var _best_depot = noone;
			var _min_trains = 9999;
			with (O_Station) {
				if (station_role == "depot") {
					var _tc = array_length(trains);
					if (_tc < _min_trains) {
						_min_trains = _tc;
						_best_depot = id;
					}
				}
			}
			if (_best_depot != noone) {
				SpawnTrainForDepot(_best_depot);
			}
			break;
		case "slow_demand":
			global.perks.demand_slow_mult = max(0.4, global.perks.demand_slow_mult * 0.85);
			break;
	}
}

function OpenWeekRewardScreen() {
	if (!instance_exists(O_WeekRewardUI)) {
		instance_create_layer(0, 0, "Instances", O_WeekRewardUI);
	}
}
