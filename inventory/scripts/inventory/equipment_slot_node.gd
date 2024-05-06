class_name EquipmentSlotNode extends InventorySlotNode

## Does as the parent func and set the placeholder
func set_slot(value):
	super.set_slot(value)
	
	if slot and not slot.item:
		%placeholder.texture = AlcarodianResourceManager.get_placeholder(slot.type)


## When the item changes, update the placeholder
func _on_item_changed():
	super._on_item_changed()
	%placeholder.visible = slot.item == null
