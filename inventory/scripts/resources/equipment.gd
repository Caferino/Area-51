class_name Equipment extends Inventory

func _init():
	slots.append(EquipmentSlot.new(0, self, GameEnums.EQUIPMENT_TYPE.HEAD))
	slots.append(EquipmentSlot.new(1, self, GameEnums.EQUIPMENT_TYPE.CHEST))
	slots.append(EquipmentSlot.new(2, self, GameEnums.EQUIPMENT_TYPE.OFFHAND))
	slots.append(EquipmentSlot.new(3, self, GameEnums.EQUIPMENT_TYPE.MAIN_HAND))
	
	for slot in slots:
		slot.item_changed.connect(_on_item_changed)


## Get the total of the given stat from all equipped items
func get_stat(stat):
	var total = 0
	for slot in slots:
		total += slot.get_stat(stat)
	return total
