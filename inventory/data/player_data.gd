class_name PlayerData extends Resource

@export var global_position: Vector2 = Vector2(368, 347)  # TODO - Check these values
@export var inventories: Dictionary

var base_stats = {
	GameEnums.STAT.STRENGTH: 5,
	GameEnums.STAT.DEXTERITY: 5,
	GameEnums.STAT.VITALITY: 5,
	GameEnums.STAT.INTELLIGENCE: 5,
	GameEnums.STAT.MOVE_SPEED: 150
}


var equipment: Equipment
var inventory_left: Inventory
var inventory_right: Inventory
var hotbar: Hotbar


# TODO - Equipment and Hotbar
# Initialise the player's inventories
func _init():
	equipment = Equipment.new().duplicate()
	equipment.name = "Equipment"
	equipment.groups = ["player", "equipment"]
	inventory_left = Inventory.new().duplicate()
	inventory_left.name = "Left Pocket"
	inventory_left.size = 5
	inventory_left.groups = ["player", "crafting"]
	inventory_right = Inventory.new().duplicate()
	inventory_right.name = "Right Pocket"
	inventory_right.size = 5
	inventory_right.groups = ["player", "crafting"]
	hotbar = Hotbar.new().duplicate()
	hotbar.size = 5


func set_data(data):
	global_position = data.global_position
	inventories = data.inventories
	emit_changed()
	changed_data()


func get_data():
	inventories.equipment = equipment.get_data()
	inventories.inventory_left = inventory_left.get_data()
	inventories.inventory_right = inventory_right.get_data()
	inventories.hotbar = hotbar.get_data()
	
	return {
		"global_position": global_position,
		"inventories": inventories
	}


func get_stat(stat):
	var stat_total = 0
	
	if base_stats.has(stat):
		stat_total += base_stats[stat]
	
	for inv in InventoryManager.get_inventories_from_group("equipment"):
		stat_total += inv.get_stat(stat)
	
	var stat_data = AlcarodianResourceManager.stat_info[stat]
	if stat_data.has("affected_by"):
		for main_stat in stat_data.affected_by:
			stat_total += get_stat(GameEnums.STAT[main_stat]) * stat_data.affected_by[main_stat]
	
	return int(round(stat_total))


func changed_data():
	if inventories.size() > 0:
		equipment.set_data(inventories.equipment)
		inventory_left.set_data(inventories.inventory_left)
		inventory_right.set_data(inventories.inventory_right)
		hotbar.set_data(inventories.hotbar)