#macro DAY_DURATION_SECONDS 12

function TimeInit() {
	global.current_week = 1;
	global.current_day = 0; // 0 = SEG ... 6 = DOM
	global.day_timer = 0;
	global.day_names = ["SEG", "TER", "QUA", "QUI", "SEX", "SAB", "DOM"];
	global.unlocked_colors = [LINE_COLOR.RED];
	global.week_pending_reward = false;
}

function OnDayAdvanced() {
	// A cada 3 dias (QUA e SAB), expande a rede com novas estacoes
	if (global.current_day == 2 || global.current_day == 5) {
		// Desbloqueia novas cores conforme as semanas avancam
		var _max_colors = min(4, global.current_week);
		if (array_length(global.unlocked_colors) < _max_colors) {
			var _new_col = array_length(global.unlocked_colors);
			array_push(global.unlocked_colors, _new_col);
			TrySpawnNewStation("depot", _new_col);
			TrySpawnNewStation("destination", _new_col);
		} else {
			var _pick = global.unlocked_colors[irandom(array_length(global.unlocked_colors) - 1)];
			var _role = (irandom(3) == 0) ? "depot" : "destination";
			TrySpawnNewStation(_role, _pick);
		}
	}
}

function TimeUpdate(_dt) {
	if (global.game_paused) {
		return;
	}

	global.day_timer += _dt * global.game_speed;
	if (global.day_timer >= DAY_DURATION_SECONDS) {
		global.day_timer -= DAY_DURATION_SECONDS;
		global.current_day += 1;

		if (global.current_day >= 7) {
			global.current_day = 0;
			global.current_week += 1;
			global.game_paused = true;
			global.week_pending_reward = true;
			OpenWeekRewardScreen();
		} else {
			OnDayAdvanced();
		}
	}
}
