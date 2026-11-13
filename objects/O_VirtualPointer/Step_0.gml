// Se o mouse se moveu, segue o tile sob o cursor do mouse
if (mouse_x != last_mouse_x || mouse_y != last_mouse_y) {
	last_mouse_x = mouse_x;
	last_mouse_y = mouse_y;
	var _mgx = clamp(WorldToGridX(mouse_x), 0, GRID_W - 1);
	var _mgy = clamp(WorldToGridY(mouse_y), 0, GRID_H - 1);
	x = GridToWorldX(_mgx) + (TILE_SIZE * 0.5);
	y = GridToWorldY(_mgy) + (TILE_SIZE * 0.5);
}

// Controle opcional por teclado (WASD)
if (keyboard_check_pressed(ord("W"))) y -= TILE_SIZE;
if (keyboard_check_pressed(ord("A"))) x -= TILE_SIZE;
if (keyboard_check_pressed(ord("S"))) y += TILE_SIZE;
if (keyboard_check_pressed(ord("D"))) x += TILE_SIZE;

x = clamp(x, TILE_SIZE * 0.5, (GRID_W - 1) * TILE_SIZE + (TILE_SIZE * 0.5));
y = clamp(y, TILE_SIZE * 0.5, (GRID_H - 1) * TILE_SIZE + (TILE_SIZE * 0.5));

// Rotacao (X ou botao do meio do mouse)
if (keyboard_check_pressed(ord("X")) || mouse_check_button_pressed(mb_middle)) {
	rot = (rot + 1) % 4;
}

var _gx = WorldToGridX(x);
var _gy = WorldToGridY(y);
var _over_hud = (device_mouse_y_to_gui(0) >= 154);

// Construir com mouse esquerdo (ou Z)
if ((mouse_check_button(mb_left) && !_over_hud) || keyboard_check_pressed(ord("Z"))) {
	var _slot = InventoryGetSelected(O_Inventory);
	if (_slot != undefined) {
		PlaceRail(_gx, _gy, rot, _slot.type);
	}
}

// Remover com mouse direito (ou L)
if ((mouse_check_button(mb_right) && !_over_hud) || keyboard_check(ord("L"))) {
	RemoveRail(_gx, _gy);
}

// Teste rapido de spawn de trem
if (keyboard_check_pressed(ord("R"))) {
	PlaceTrain(x, y, rot, 0);
}
