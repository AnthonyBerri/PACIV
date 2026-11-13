station_role = "destination"; // "depot" ou "destination"
line_color = LINE_COLOR.RED;

gx = 0;
gy = 0;
w_tiles = 4;
h_tiles = 4;
entry_gx = 0;
entry_gy = 0;

// Deposito (spawn de trens)
trains = [];

// Destino (requerimentos e sobrecarga)
demand_count = 1;
max_demand = 6;
demand_interval = 7.0; // segundos entre pedidos
demand_timer = 0;

overload_timer = 0;
overload_max = 18.0; // segundos em sobrecarga antes do Game Over

