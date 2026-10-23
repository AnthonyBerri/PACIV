function InventoryManager(O_Inventory){
	if(mouse_wheel_up()){
		O_Inventory.selected_slot = (O_Inventory.selected_slot + 1) % O_Inventory.inventory_size
	}
	if(mouse_wheel_down()){
		O_Inventory.selected_slot = (((O_Inventory.selected_slot - 1) % O_Inventory.inventory_size) + O_Inventory.inventory_size) % O_Inventory.inventory_size
	}
}

function DrawInventory(O_Inventory){
	for(var i = 0; i < O_Inventory.inventory_size; i++){
		draw_sprite(S_InventorySlot, 0, room_width / 2 + (i * 7), room_height / 2)
		if(O_Inventory.selected_slot == i){
			draw_sprite(S_SelectedFlag, 0, room_width / 2 + (i * 7), (room_height / 2) - 10)
		}
	}
}