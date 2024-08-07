class_name ItemInfo extends ScaleControl

## Display the hovered item info
## Each components on the item also adds their info
func display(slot_node: InventorySlotNode):
	for c in %line_container.get_children():
		%line_container.remove_child(c)
		c.queue_free()
	
	var slot = slot_node.slot
	%item_name.text = slot.item.get_item_name()
	var rarity_name = GameEnums.RARITY.keys()[slot.item.rarity].capitalize()
	var line_type = ItemInfoLine.new(rarity_name + " " + ItemManager.get_type_name(slot.item), slot.item.rarity)
	%line_container.add_child(line_type)
	
	for c in slot.item.components.values():
		c.set_info(self)
	
	size = Vector2.ZERO
	show()
	
	global_position = (slot_node.size * SettingsManager.ui_scale) + slot_node.global_position
	var window_size = get_viewport().get_visible_rect().size
	var scaled = (size * scale)
	
	if global_position.y + scaled.y > window_size.y:
		global_position.y = window_size.y - scaled.y
	
	if global_position.x + scaled.x > window_size.x:
		global_position.x = slot_node.global_position.x - scaled.x


## Add a line node in the list
func add_line(line):
	%line_container.add_child(line)


## Add a splitter line in the list
func add_splitter():
	add_line(AlcarodianResourceManager.tscn.splitter.instantiate())
