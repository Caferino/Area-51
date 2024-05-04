extends ResourcePreloader

const ITEM_PATH = ""
const AFFIXES_PATH = ""
const RARE_NAMES_PATH = ""

var items = {}
var rare_items = {}
var affix_groups = {}


var equipment_names = {
	GameEnums.EQUIPMENT_TYPE.HEAD: "Head",
	GameEnums.EQUIPMENT_TYPE.CHEST: "Armor",
	GameEnums.EQUIPMENT_TYPE.OFFHAND: "Offhand",
	GameEnums.EQUIPMENT_TYPE.MAIN_HAND: "Weapon"
}


var type_names = {
	GameEnums.ITEM_TYPE.CONSUMABLE: "Consumable",
	GameEnums.ITEM_TYPE.CURRENCY: "Currency",
	GameEnums.ITEM_TYPE.MATERIAL: "Material"
}


var usable = {
	"healing": preload(),
	"upgrade": preload()
}







# MINE, OG, TODO - FUSE WITH get_inventory_item()
@onready var my_items = {
	"wooden_logs" : preload("res://Labs/Scenes/Collectable Items & Inventory/New Inventory System 1.0/Inventory/Inventory System/Logs.tscn"),
	"gold_coins" : preload("res://Labs/Scenes/Collectable Items & Inventory/New Inventory System 1.0/Inventory/Inventory System/Gold.tscn"),
	"gem" : preload("res://Labs/Scenes/Collectable Items & Inventory/New Inventory System 1.0/Inventory/Inventory System/Gem.tscn"),
}

func get_item(id: String):
	return my_items[id].instantiate()


func drop_item(item, position, loot_radius, scene):
	if ItemManager.has_resource(item):
		item = ItemManager.get_resource(item)
		var collectable = ItemManager.get_resource("collectable").instantiate()
		
		collectable.setup(item)
		collectable.global_position = position
		scene.add_child(collectable)
		
		collectable.drop(loot_radius)
