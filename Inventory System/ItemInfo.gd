extends NinePatchRect

@export_node_path var item_name_path
@onready var item_name = get_node(item_name_path) as Label


func display(slot: InventorySlot):
	global_position = slot.size + slot.global_position
	item_name.text = slot.item.item_name
	show()
