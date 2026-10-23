if(keyboard_check_pressed(ord("Z"))){
	PlaceRail(x, y, rot, 9);
}

if(keyboard_check_pressed(ord("X"))){
	rot = (rot + 1) % 4;
}

if(keyboard_check_pressed(ord("W"))){
	y-=8
}

if(keyboard_check_pressed(ord("A"))){
	x-=8
}

if(keyboard_check_pressed(ord("S"))){
	y+=8
}

if(keyboard_check_pressed(ord("D"))){
	x+=8
}

