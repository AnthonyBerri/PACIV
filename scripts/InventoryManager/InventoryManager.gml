enum RAIL_TYPE {
	STRAIGHT = 0,
	TURN = 1,
	CROSS = 2
}

function InventoryManager(_inv) {
	if (mouse_wheel_up()) {
		_inv.selected_slot = (_inv.selected_slot + 1) % _inv.inventory_size;
	}
	if (mouse_wheel_down()) {
		_inv.selected_slot = (((_inv.selected_slot - 1) % _inv.inventory_size) + _inv.inventory_size) % _inv.inventory_size;
	}

	if (keyboard_check_pressed(ord("1"))) _inv.selected_slot = 0;
	if (keyboard_check_pressed(ord("2")) && _inv.inventory_size > 1) _inv.selected_slot = 1;
	if (keyboard_check_pressed(ord("3")) && _inv.inventory_size > 2) _inv.selected_slot = 2;
}

function InventoryGetSelected(_inv) {
	if (!instance_exists(_inv) || _inv.selected_slot < 0 || _inv.selected_slot >= array_length(_inv.slots)) {
		return undefined;
	}
	return _inv.slots[_inv.selected_slot];
}

function InventoryFindSlot(_inv, _type) {
	if (!instance_exists(_inv)) return undefined;
	for (var i = 0; i < array_length(_inv.slots); i++) {
		if (_inv.slots[i].type == _type) {
			return _inv.slots[i];
		}
	}
	return undefined;
}

function InventoryHasStock(_inv, _type) {
	var _slot = InventoryFindSlot(_inv, _type);
	return (_slot != undefined && _slot.unlocked && _slot.count > 0);
}

function InventoryConsume(_inv, _type) {
	var _slot = InventoryFindSlot(_inv, _type);
	if (_slot != undefined && _slot.unlocked && _slot.count > 0) {
		_slot.count -= 1;
		return true;
	}
	return false;
}

function InventoryRefund(_inv, _type) {
	var _slot = InventoryFindSlot(_inv, _type);
	if (_slot != undefined) {
		_slot.count += 1;
	}
}

function DrawInventory(_inv) {
	var _slot_spacing = 18;
	var _total_w = _inv.inventory_size * _slot_spacing;
	var _start_x = (320 - _total_w) * 0.5 + (_slot_spacing * 0.5);
	var _y = 166;

	draw_set_halign(fa_center);
	draw_set_valign(fa_top);

	for (var i = 0; i < _inv.inventory_size; i++) {
		var _sx = _start_x + (i * _slot_spacing);
		var _slot = _inv.slots[i];

		draw_sprite(S_InventorySlot, 0, _sx - 4, _y - 4);

		if (_slot.unlocked) {
			if (_slot.type == RAIL_TYPE.CROSS) {
				draw_sprite(S_StraightRail, 0, _sx, _y);
				draw_sprite_ext(S_StraightRail, 0, _sx, _y, 1, 1, 90, c_white, 1);
			} else {
				draw_sprite(_slot.sprite, 0, _sx, _y);
			}

			var _col = (_slot.count > 0) ? c_white : c_red;
			draw_text_transformed_color(_sx, _y + 5, string(_slot.count), 0.45, 0.45, 0, _col, _col, _col, _col, 1);
		} else {
			draw_sprite_ext(_slot.sprite, 0, _sx, _y, 1, 1, 0, c_dkgray, 0.4);
			draw_text_transformed_color(_sx, _y + 5, "-", 0.45, 0.45, 0, c_gray, c_gray, c_gray, c_gray, 1);
		}

		if (_inv.selected_slot == i) {
			draw_sprite(S_SelectedFlag, 0, _sx - 4, _y - 14);
		}
	}

	draw_set_halign(fa_left);
}
