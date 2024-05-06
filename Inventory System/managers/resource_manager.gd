class_name AlcarodianResourceManager extends Node

const STAT_PATH = "" # TODO jsons
const RECIPE_PATH = ""


var sprites = {  # TODO
	"gold": preload("res://Labs/Scenes/Collectable Items & Inventory/Gold.png"),
	"logs": preload("res://Labs/Scenes/Collectable Items & Inventory/Logs.png"),
	"gem": preload("res://Labs/Scenes/Collectable Items & Inventory/Gem.png")
}

var fonts = {
	"Arcadepix": preload("res://Inventory System/resources/font/Arcadepix Plus.ttf")
}

var colors = {
	GameEnums.RARITY.NORMAL : Color("CCCCCC"),
	GameEnums.RARITY.MAGIC : Color("4D8EFF"),
	GameEnums.RARITY.RARE : Color("FFCC00"),
	GameEnums.RARITY.UNIQUE : Color("FF00FF")
}

var tscn = {  # TODO jsons
	#"Splitter": preload(),
	#"HotbarSlotNode": preload(),
	#"FloorItem": preload(),
	#"Cooldown": preload(),
	#"CraftingOption": preload(),
	#"ItemQuantity": preload(),
	#"InventorySlotNode": preload(),
	#"InventoryNode": preload(),
	#"ItemNode": preload(),
	#"EquipmentNode": preload()
}

@onready var placeholders = {  # TODO jsons
	#GameEnums.EQUIPMENT_TYPE.HEAD: preload("")
	#GameEnums.EQUIPMENT_TYPE.CHEST: preload("")
	#GameEnums.EQUIPMENT_TYPE.MAIN_HAND: preload("")
	#GameEnums.EQUIPMENT_TYPE.OFFHAND: preload("")
}

var stat_info = {}
var recipes_info = {}


func _ready():
	var json = JSON.new()
	
	# Load the stats
	var file = FileAccess.open(STAT_PATH, FileAccess.READ)
	json.parse(file.get_as_text())
	var data = json.get_data()
	for stat in data:
		stat_info[GameEnums.STAT[stat]] = data[stat]
	
	# Load the recipes
	file = FileAccess.open(RECIPE_PATH, FileAccess.READ)
	json.parse(file.get_as_text())
	recipes_info = json.get_data()


## Get a prefab scene instance from its ID
func get_instance(id):
	return tscn[id].instantiate()


## Get the recipe from its id
func get_recipe(id):
	return recipes_info[id]


## Get the placeholder sprite for the equipment slot
func get_placeholder(id):
	return placeholders[id]


## Get the item node to be displayed in a slot
func get_item_node(item):
	var item_node = tscn.item_node.instantiate()
	item_node.item = item
	item_node.texture = sprites[item.id]
	return item_node
