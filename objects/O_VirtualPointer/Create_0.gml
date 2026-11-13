// Alinha ao centro da celula 8x8 e rastreia movimento do mouse
x = clamp(WorldToGridX(x), 0, GRID_W - 1) * TILE_SIZE + (TILE_SIZE * 0.5);
y = clamp(WorldToGridY(y), 0, GRID_H - 1) * TILE_SIZE + (TILE_SIZE * 0.5);

last_mouse_x = mouse_x;
last_mouse_y = mouse_y;