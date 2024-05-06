class_name InventoryNode extends InnerPanel

var is_open = false
var slots_node: Array = []
var inventory: Inventory: set = set_inventory


func set_inventory(value):
	inventory = value
	
	if inventory:
		draw_slots()
		set_title(inventory.name)


## Instantiate each visual slot
func draw_slots():
	for s in inventory.slots:
		var slot_node = AlcarodianResourceManager.get_instance("inventory_slot_node")
		%slot_container.add_child(slot_node)
		slot_node.slot = s
