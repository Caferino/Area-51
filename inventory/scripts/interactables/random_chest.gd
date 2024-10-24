extends Chest

@export var num_of_items: int


## Randomly pick an item from the loot table and roll for rarity and stats
func set_items():
	for nb in num_of_items:
		var item = ItemManager.get_item(loot_table[randi() % loot_table.size()])
		
		if item.equipment_type != GameEnums.EQUIPMENT_TYPE.NONE:
			ItemManager.generate_random_rarity(item, 100)
		
		item.quantity = item.stack_size
		inventory.add_item(item)
