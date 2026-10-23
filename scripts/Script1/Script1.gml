
x = 0
y = 0

function VirtualPointer(){
	if keyboard_check(ord("W")){
		y -= 8
	}
	
	if keyboard_check(ord("A")){
		x -= 8
	}
	
	if keyboard_check(ord("S")){
		y += 8
	}
	
	if keyboard_check(ord("D")){
		x += 8
	}
	
	show_debug_message("X : " + string(x) + "/n");
	show_debug_message("Y : " + string(y) + "/n");
}