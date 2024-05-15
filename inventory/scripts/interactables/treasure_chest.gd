extends Chest


func set_items():
	pass


## For each slot, get a new item and roll its rarity
func interact():
	for s in inventory.slots:
		s.put_item(null)
	
	for nb in inventory.slots.size():
		inventory.add_item(ItemManager.rng_generate_rarity(100))
	
	SignalManager.inventory_opened.emit(inventory)
