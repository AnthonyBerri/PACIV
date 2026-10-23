if(keyboard_check(ord("L"))){
	var _rail = instance_destroy(other)
	var _index = array_get_index(global.rails, _rail)
	show_debug_message("Achou Deletou")
	array_delete(global.rails, _index, 1)
	
}