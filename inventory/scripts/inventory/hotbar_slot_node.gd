class_name HotbarSlotNode extends InventorySlotNode

func set_slot(value):
	super.set_slot(value)
	set_key()


## If you press this slot's key, activate the item if possible
func _input(event):
	if event.is_action_pressed("hotbar_" + slot.key) and slot.item and slot.item.components.has("usable"):
		print("Used hotbar slot: ", slot.key)
		slot.item.components.usable.use()


## Set the key to be pressed to activate this slot
func set_key():
	if %lbl_key is Label:
		%lbl_key.text = slot.key
