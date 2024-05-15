class_name InventorySlot extends Resource

## Emitted when the item has changed
signal item_changed()

var item: Item
var groups: Array = []
var index: int
var inventory
var can_split = true
var can_drop = true


## Sets the index of the slot and the parent inventory
func _init(i, inv):
	index = i
	inventory = inv


## Sets the item in the slots
## Used to force it in, won't validate anything
## Use put_item to do the verification
func set_item(new_item):
	unset_old_item()
	item = new_item
	set_new_item()
	item_changed.emit()


## Remove the slot from the node and disconnect signals
func unset_old_item():
	if item:
		item.slot = null
		item.depleted.disconnect(_on_item_depleted)


## Add the slot to the node and connect signals
func set_new_item():
	if item:
		item.slot = self
		item.depleted.connect(_on_item_depleted)


## Check if the item can go in the slot
func accept_item(new_item) -> bool:
	return new_item and not item


## Test if an item can be placed in the slot
func try_put_item(new_item: Item) -> bool:
	return accept_item(new_item) or (item.id == new_item.id and item.quantity < item.stack_size)


## Put a new item in the slot
## Returns the old item if it was swapped
## Returns the new item if it was rejected
## Returns null if it's accepted but the slot was empty
func put_item(new_item: Item) -> Item:
	if new_item:
		# We try to place an item
		return has_new_item(new_item)
	
	elif item:
		# We want to pick up the item already in the slot with an empty hand
		new_item = item
		set_item(null)
	
	# Return the item or null
	return new_item


## If there is an item in your hand
func has_new_item(new_item):
	if item:
		# There is already an item in the slot
		return has_both_item(new_item)
	else:
		# Place the item in the empty slot
		set_item(new_item)
		return null


## If there is an item in your hand and the slot
func has_both_item(new_item):
	if can_stack(new_item):
		# Check if the item in hand and the one in the slot can be stacked
		var remainder = item.add_item_quantity(new_item.quantity)
		new_item.quantity = remainder
		item_changed.emit()
	else:
		# Swap the item in hand with the one in the slot
		var temp_item = item
		set_item(new_item)
		new_item = temp_item
	return new_item if new_item.quantity > 0 else null


## Check if an item can be stacked into this slot
func can_stack(new_item) -> bool:
	return item.id == new_item.id and item.quantity < item.stack_size


## Completely remove the item from the slot
func remove_item():
	put_item(null)


## Add an Inventory Group to the slot
func add_group(group_id):
	groups.append(group_id)


## Remove the item and send the dropped signal
func drop_item():
	var old_item = item
	set_item(null)
	SignalManager.item_dropped.emit(old_item)


## Remove the item, but add gold coins
func sell_item():
	remove_item()
	InventoryManager.add_items([ItemManager.get_item("gold_coin")], "player")


## Remove the item if it reaches 0 quantity
func _on_item_depleted():
	remove_item()
