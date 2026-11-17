randomize();

window_set_size(1600, 900);
display_set_gui_size(320, 180);
surface_resize(application_surface, 320, 180);

global.game_paused = false;
global.game_over = false;
global.game_speed = 1;
global.overload_station = noone;
global.rails = [];
global.debug_info = "";
global.debug_last_cell = "none";
global.debug_overlay = false;

GridInit();
ScoreInit();
TimeInit();
PerkInit();
SpawnInitialStations();
