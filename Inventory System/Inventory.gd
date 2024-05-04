class_name Inventory extends Resource

## SIGNALS ##

signal content_changed()
signal size_changed()


## VARIABLES ##
@export var name : String
@export var size : int = 0 : set = set_inventory_size

var groups : Array = []: set = set_groups
var slots : Array = []
var has_upgradable_items = false


## SETTERS ##

func set_inventory_size(value):
	size = value
	
	if slots.size() > value:
		for s in range(size - 1, -1, -1):
			slots.remove_at(s)
	else:
		for s in range(slots.size(), size):
			var slot = get_new_slot(s)
			slot.groups = groups
			slots.append(slot)
			slot.item_changed.connect(_on_item_changed)
	size_changed.emit()


func set_groups(value):
	groups = value
	
	for s in slots:
		s.groups = value


## FUNCTIONS ##

func get_new_slot(s):
	return InventorySlot.new(s, self)


# Place item in the first available stack or slot
# Returns what remains if it can't place it
func add_item(item):
	# Place items that can stack on unfinished stacks first
	if item.stack_size > 1:
		for s in slots:
			if s.item and s.item.id == item.id and s.item.quantity < s.item.stack_size:
				item = s.put_item(item)
				if item == null: break
	# Place item on first available slot
	if item:
		for s in slots:
			if s.try_put_item(item):
				item = s.put_item(item)
				if not item: break
	content_has_changed()
	return item


func try_place_stack_items(items: Array):
	for s in slots:
		if s.item and s.item.quantity < s.item.stack_size:
			var free_space = s.item.stack_size - s.item.quantity
			for i in range(items.size() - 1, -1, -1):
				if s.item.id == items[i].id:
					if items[i].quantity <= free_space:
						free_space -= items[i].quantity
						items.remove_at(i)
					else:
						items[i].quantity -= free_space
						break
	return items


# Check to see if the inventory accepts the given items
# If accepted, they are removed. Returns remaining items
func accept_items(items: Array):
	for s in slots:
		for i in range(items.size() - 1, -1, -1):
			if s.accept_item(items[i]):
				items.remove_at(i)
				break
	return items


# Check if it contains upgradable items
func set_upgradable_items():
	for s in slots:
		if s.item and s.item.type == Game_Enums.ITEM_TYPE.EQUIPMENT and s.item.rarity < Game_Enums.RARITY.RARE:
			has_upgradable_items = true
			return
	has_upgradable_items = false


# Count the items that have the give id
func get_item_count(id):
	var count = 0
	for s in slots:
		if s.item and s.item.id == id:
			count += s.item.quantity
	return count


# Remove specified amount of the given item id
# Returns the remaining quantity to remove
func remove_item_quantity(id, quantity):
	for s in range(slots.size() - 1, -1, -1):
		if slots[s].item and sots[s].item.id == id:
			if quantity >= slots[s].item.quntity:
				quantity -= slots[s].item.quantity
				slots[s].item.quantity = 0
				slots[s].item = null
			else:
				slots[s].item.quantity -= quantity
				content_has_changed()
				return 0
	content_has_changed()
	return quantity


func content_has_changed():
	set_upgradable_items()
	content_changed.emit(groups)


func get_data() -> Dictionary:
	var data = {}
	for s in slots.size():
		if slots[s].item:
			data[s] = slots[s].item.get_data()
	return data


func set_data(data):
	for i in slots.size():
		slots[i].put_item(null)
		if data.has(i):
			slots[i].put_item(ItemManager.get_item_from_data(data[i]))


## SIGNAL CONNEXIONS ##

func _on_item_changed():
	content_has_changed()
