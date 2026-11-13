var _gx = WorldToGridX(x);
var _gy = WorldToGridY(y);
var _slot = InventoryGetSelected(O_Inventory);

if (_slot != undefined && _slot.unlocked) {
	var _can = CanPlaceRail(_gx, _gy, _slot.type);
	var _col = _can ? c_lime : c_red;

	if (_slot.type == RAIL_TYPE.CROSS) {
		draw_sprite_ext(S_StraightRail, 0, x, y, 1, 1, 0, _col, 0.55);
		draw_sprite_ext(S_StraightRail, 0, x, y, 1, 1, 90, _col, 0.55);
	} else {
		draw_sprite_ext(_slot.sprite, 0, x, y, 1, 1, 90 * rot, _col, 0.55);
	}
}

draw_self();

