function ScoreInit() {
	global.score = 0;
	global.deliveries_this_week = 0;
}

function AddDeliveryScore(_wx, _wy) {
	global.score += 1;
	global.deliveries_this_week += 1;

	var _fx = instance_create_layer(_wx, _wy - 8, "Instances", O_FloatingText);
	_fx.text = "+1";
}

function TriggerGameOver(_station) {
	if (global.game_over) return;
	global.game_over = true;
	global.game_paused = true;
	global.overload_station = _station;

	if (!instance_exists(O_GameOverUI)) {
		instance_create_layer(0, 0, "Instances", O_GameOverUI);
	}
}
