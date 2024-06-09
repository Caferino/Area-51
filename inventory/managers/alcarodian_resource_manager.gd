extends Node

const STAT_PATH   : String = "res://inventory/data/json/stats.json"
const RECIPE_PATH : String = "res://inventory/data/json/recipes.json"

# TODO - ! Using preload fills the memory if too many? Should load() be used instead? Aka "Lazy Loading"

var sprites: Dictionary = {
	"gold"                 : preload("res://Labs/Scenes/Collectable Items & Inventory/Gold.png"),
	"logs"                 : preload("res://Labs/Scenes/Collectable Items & Inventory/Logs.png"),
	"gem"                  : preload("res://Labs/Scenes/Collectable Items & Inventory/Gem.png"),
	"chestplate"           : preload("res://inventory/resources/sprites/items/chestplate.png"),
	"crystal"              : preload("res://inventory/resources/sprites/items/crystal.png"),
	"gold_coin"            : preload("res://inventory/resources/sprites/items/gold_coin.png"),
	"helmet"               : preload("res://inventory/resources/sprites/items/helmet.png"),
	"iron_sword"           : preload("res://inventory/resources/sprites/items/iron_sword.png"),
	"magic_orb"            : preload("res://inventory/resources/sprites/items/magic_orb.png"),
	"shield"               : preload("res://inventory/resources/sprites/items/shield.png"),
	"stone_brick"          : preload("res://inventory/resources/sprites/items/stone_brick.png"),
	"tshirt"               : preload("res://inventory/resources/sprites/items/tshirt.png"),
	"wood"                 : preload("res://inventory/resources/sprites/items/wood.png"),
	"wooden_sword"         : preload("res://inventory/resources/sprites/items/wooden_sword.png"),
	"small_healing_potion" : preload("res://inventory/resources/sprites/items/small_red_potion.png"),
	"big_healing_potion"   : preload("res://inventory/resources/sprites/items/big_red_potion.png"),
	"rarity_upgrade"       : preload("res://inventory/resources/sprites/items/rarity_upgrade.png"),
	"plank"                : preload("res://inventory/resources/sprites/items/plank.png"),
	"rock"                 : preload("res://inventory/resources/sprites/items/rock.png")
}

var fonts: Dictionary = {
	"Arcadepix" : preload("res://inventory/resources/font/Arcadepix Plus.ttf")
}

var colors: Dictionary = {
	GameEnums.RARITY.NORMAL : Color("CCCCCC"),
	GameEnums.RARITY.MAGIC  : Color("4D8EFF"),
	GameEnums.RARITY.RARE   : Color("FFCC00"),
	GameEnums.RARITY.UNIQUE : Color("FF00FF")
}

var tscn: Dictionary = {
	"splitter"            : preload("res://inventory/scenes/ui/splitter.tscn"),
	"hotbar_slot_node"    : preload("res://inventory/scenes/inventory/hotbar_slot_node.tscn"),
	"floor_item"          : preload("res://inventory/scenes/interactables/floor_item.tscn"),
	"cooldown"            : preload("res://inventory/scenes/ui/cooldown.tscn"),
	"crafting_option"     : preload("res://inventory/scenes/ui/crafting_option.tscn"),
	"item_quantity"       : preload("res://inventory/scenes/ui/item_quantity.tscn"),
	"inventory_slot_node" : preload("res://inventory/scenes/inventory/inventory_slot_node.tscn"),
	"inventory_node"      : preload("res://inventory/scenes/inventory/inventory_node.tscn"),
	"item_node"           : preload("res://inventory/scenes/inventory/item_node.tscn"),
	"equipment_node"      : preload("res://inventory/scenes/inventory/equipment_node.tscn")
}

var placeholders: Dictionary = {
	GameEnums.EQUIPMENT_TYPE.HEAD      : preload("res://inventory/resources/sprites/placeholder_head.png"),
	GameEnums.EQUIPMENT_TYPE.CHEST     : preload("res://inventory/resources/sprites/placeholder_chest.png"),
	GameEnums.EQUIPMENT_TYPE.MAIN_HAND : preload("res://inventory/resources/sprites/placeholder_main_hand.png"),
	GameEnums.EQUIPMENT_TYPE.OFFHAND   : preload("res://inventory/resources/sprites/placeholder_offhand.png")
}

## TODO ! Move this to Bizck maybe, Bizck as a autoloaded manager with stats and sprites
var animals: Dictionary = {
	"CaveBat" = {
		GameEnums.AI_STATS.DEFAULT_MAX_SPEED      : 250,
		GameEnums.AI_STATS.DEFAULT_LOOK_AHEAD     :  50,
		GameEnums.AI_STATS.DEFAULT_ADDED_INTEREST : 5.0,
		GameEnums.AI_STATS.DEFAULT_NUM_RAYS       :   8, # TODO - Maybe this should never change at all for most entities (1)
		GameEnums.AI_STATS.DEFAULT_BACKOFF_SPEED  : 0.2
	}
}

var stat_info    : Dictionary = {}
var recipes_info : Dictionary = {}


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
