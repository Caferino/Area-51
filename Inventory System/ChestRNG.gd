extends Chest


@export var num_of_items: int


func set_items():
	for nb in num_of_items:
		inventory.add_item(ItemManager.get_item(items[randi() % items.size()]))
