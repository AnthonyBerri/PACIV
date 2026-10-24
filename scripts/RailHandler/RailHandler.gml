global.rails = []

function PlaceRail(rx, ry, rrot, rt) {
	var _len = array_length(global.rails);
	var i = 0;
	for(i = 0; i < _len; i++){
		if (global.rails[i].x == rx and global.rails[i].y == ry) {
			return
		}
	}
	
	var _rail = instance_create_layer(rx, ry, "Instances", O_StraightRail);
	_rail.rot = rrot;
	_rail.type = rt;
	_rail.image_angle = 90 * rrot;
	array_push(global.rails, _rail);
	
	show_debug_message("Rails: " + string(_len) + "\n")
	show_debug_message("Rot: " + string(rrot))
}

function PlaceTrain(rx, ry, rrot, rt) {
	
	var _rail = instance_create_layer(rx, ry - 5, "Trains", O_Train);
	
	// show_debug_message("Train: "  + "\n")
	// show_debug_message("Rot: " + string(rrot))
}

