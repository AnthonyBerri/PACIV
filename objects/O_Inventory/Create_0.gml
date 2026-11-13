slots = [
	{ type: RAIL_TYPE.STRAIGHT, sprite: S_StraightRail, count: 35, unlocked: true },
	{ type: RAIL_TYPE.TURN,     sprite: S_TurnRail,     count: 15, unlocked: true },
	{ type: RAIL_TYPE.CROSS,    sprite: S_StraightRail, count: 0,  unlocked: false }
];

inventory_size = array_length(slots);
selected_slot = 0;
