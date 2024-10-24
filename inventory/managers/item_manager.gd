extends Node

const ITEM_PATH = "res://inventory/data/json/items.json"
const AFFIXES_PATH = "res://inventory/data/json/affixes.json"
const RARE_NAMES_PATH = "res://inventory/data/json/rare_names.json"

## These might go in a StructureManager
var curr_structure : Node2D = null
var curr_area : Area2D = null

var items = {}
var structures = {}  ## TODO - Will I maybe need a global structure_manager?
var rare_names = {}
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
	"healing": preload("res://inventory/scripts/resources/usable_items/item_healing.gd"),
	"upgrade": preload("res://inventory/scripts/resources/usable_items/item_upgrade.gd")
}


## Get a random seed for the random functions
func _init():
	randomize()


## Load the content of the data files
func _ready():
	var json = JSON.new()
	
	# items
	var file = FileAccess.open(ITEM_PATH, FileAccess.READ)
	json.parse(file.get_as_text())
	items = json.get_data()
	
	# names
	file = FileAccess.open(RARE_NAMES_PATH, FileAccess.READ)
	json.parse(file.get_as_text())
	rare_names = json.get_data()
	
	# affixes group
	file = FileAccess.open(AFFIXES_PATH, FileAccess.READ)
	json.parse(file.get_as_text())
	var data = json.get_data()
	for id in data:
		affix_groups[id] = AffixGroup.new(id, data[id])


## Build the item of the given id
## This and probably most functions will have to adapt to the game
func get_item(id: String) -> Item:
	var data = items[id]
	var item = Item.new()
	item.id = id
	item.name = data.name
	item.level = data.level
	item.type = GameEnums.ITEM_TYPE[data.type]
	
	if item.type == GameEnums.ITEM_TYPE.EQUIPMENT: item.equipment_type = GameEnums.EQUIPMENT_TYPE[data.equipment_type]
	if data.has("rarity"): item.rarity = GameEnums.RARITY[data.rarity]
	if data.has("stack_size"): item.stack_size = data.stack_size
	if data.has("base_stats"): item.components["base_stats"] = BaseStat.new(data.base_stats)
	if data.has("unique"): item.unique_data = data["unique"]
	if data.has("usable"): item.components["usable"] = ItemManager.get_usable(data.usable, item)
	return item


## Build multiple items at once with the array of ids
func get_items(items_data: Array) -> Array:
	var items_array = []
	for item_data in items_data:
		items_array.append(get_item_from_data(item_data))
	return items_array


## Build an item from a dictionary (usually from item.get_data())
func get_item_from_data(item_data):
	var item = get_item(item_data.id)
	item.quantity = item_data.quantity
	if item_data.has("item_name"): item.name = item_data.item_name
	if item_data.has("rarity"): item.rarity = item_data.rarity
	if item_data.has("components"):
		if item_data.components.has("base_stats"): item.components.base_stats.scale = item_data.components.base_stats
		if item_data.components.has("affix_list"): item.components.affix_list = ItemAffixList.new(item_data.components.affix_list, item.rarity)
		if item_data.components.has("unique_stats"): set_unique(item, item_data.components.unique_stats)
	return item


## Get random equippable item
func rng_generate_rarity(ilvl) -> Item:
	var valid_items_key = []
	for i in items:
		if items[i].has("type") and ilvl >= items[i].level and GameEnums.ITEM_TYPE[items[i].type] == GameEnums.ITEM_TYPE.EQUIPMENT:
			valid_items_key.append(i)
	var item = get_item(valid_items_key[randi() % valid_items_key.size()])
	return generate_random_rarity(item, ilvl)


## Randomly select a rarity for the item
func generate_random_rarity(item, ilvl):
	item.components.base_stats.scale = randf()
	
	# Get random rarity
	var rarity = GameEnums.RARITY.NORMAL
	var rng = randf()
	if rng >= 0 and item.unique_data:  # 1%
		rarity = GameEnums.RARITY.UNIQUE
	elif rng >= 0.9:                   # 9%
		rarity = GameEnums.RARITY.RARE
	elif rng >= 0.6:                   # 30%
		rarity = GameEnums.RARITY.MAGIC
	
	generate_rarity(item, ilvl, rarity)
	return item


## Randomly selects affixes / stats for the item based on its rarity
func generate_rarity(item, ilvl, rarity) -> Item:
	item.rarity = rarity
	var number_of_affixes = 0
	
	if rarity == GameEnums.RARITY.UNIQUE:
		item.rarity = GameEnums.RARITY.UNIQUE
		roll_unique(item)
		return item
	elif rarity == GameEnums.RARITY.RARE:
		item.rarity = GameEnums.RARITY.RARE
		number_of_affixes = (randi() % 3) + 3
		set_rare_name(item)
	elif rarity == GameEnums.RARITY.MAGIC:
		item.rarity = GameEnums.RARITY.MAGIC
		number_of_affixes = (randi() % 2) + 1
	else:
		return item
	
	# Set the affixes
	var random_affix_group = get_random_affix_group(number_of_affixes, item.equipment_type, ilvl)
	var item_affix_list_data = []
	
	for affix_group in random_affix_group:
		var data = {
			"affix_group": affix_group.id,
			"affix": affix_group.get_random_affix(ilvl),
			"scale": randf()
		}
		item_affix_list_data.append(data)
	
	item.components["affix_list"] = ItemAffixList.new(item_affix_list_data, item.rarity)
	return item


## Randomly selects affixes for the item based on its rarity and level
func get_random_affix_group(affix_amount, item_type, ilvl) -> Array:
	var valid_prefixes: Array = get_valid_affixes_group(GameEnums.AFFIX_TYPE.PREFIX, item_type, ilvl)
	var valid_suffixes: Array = get_valid_affixes_group(GameEnums.AFFIX_TYPE.SUFFIX, item_type, ilvl)
	
	valid_prefixes.shuffle()
	valid_suffixes.shuffle()
	
	var prefix_amount = int(floor(affix_amount / 2.0))
	var suffix_amount = prefix_amount
	
	if affix_amount % 2 == 1:
		if randi() % 2 == 1:
			prefix_amount += 1
		else:
			suffix_amount += 1
	
	valid_prefixes.resize(prefix_amount)
	valid_suffixes.resize(suffix_amount)
	
	var valid_affixes = []
	valid_affixes.append_array(valid_prefixes)
	valid_affixes.append_array(valid_suffixes)
	return valid_affixes


## Get the possible affixes on the item based on the level and its equipment type
func get_valid_affixes_group(affix_type, item_type, ilvl):
	var valid_affixes: Array = []
	
	for id in affix_groups:
		if affix_groups[id].type == affix_type and ilvl >= affix_groups[id].affixes.values()[0].min_level and affix_groups[id].apply_to.has(item_type):
			valid_affixes.append(affix_groups[id])
	return valid_affixes


## Sets a random name for rare items
func set_rare_name(item):
	var type = GameEnums.EQUIPMENT_TYPE.keys()[item.equipment_type]
	var name_prefix_type = rare_names.prefix[type]
	var name_prefix = name_prefix_type[randi() % name_prefix_type.size()]
	var name_suffix_type = rare_names.suffix[type]
	var name_suffix = name_suffix_type[randi() % name_suffix_type.size()]
	item.name = name_prefix + " " + name_suffix


## Roll the weight for the unique stats
func roll_unique(item):
	var scales = []
	for s in item.unique_data.stats:
		scales.append(randf())
	set_unique(item, scales)


## Sets the unique data on the ite,
func set_unique(item, scales):
	item.name = item.unique_data.name
	item.components["unique_stats"] = ItemUniqueStats.new(item.unique_data.stats, scales)
	if item.unique_data.has("usable"):
		set_usable(item, item.unique_data)


## Get the usable script for the item and sets its data
func get_usable(data_usable, item):
	return usable[data_usable.type].new(data_usable.data, item)


## Set the usable script on an existing item with the given data
func set_usable(item, data):
	item.components["usable"] = get_usable(data.usable, item)


## Get the name of an item type to display
func get_type_name(item):
	if item.type == GameEnums.ITEM_TYPE.EQUIPMENT:
		return equipment_names[item.equipment_type]
	else:
		return type_names[item.type]



# MINE, OG, TODO - FUSE WITH get_inventory_item()
#@onready var my_items = {
	#"wooden_logs" : preload("res://Labs/Scenes/Collectable Items & Inventory/New Inventory System 1.0/Inventory/Inventory System/Logs.tscn"),
	#"gold_coins" : preload("res://Labs/Scenes/Collectable Items & Inventory/New Inventory System 1.0/Inventory/Inventory System/Gold.tscn"),
	#"gem" : preload("res://Labs/Scenes/Collectable Items & Inventory/New Inventory System 1.0/Inventory/Inventory System/Gem.tscn"),
#}
#
#func get_item(id: String):
	#return my_items[id].instantiate()


func drop_item(item, global_position, loot_radius, scene):
	if ItemManager.has_resource(item):
		item = ItemManager.get_resource(item)
		var collectable = ItemManager.get_resource("collectable").instantiate()
		
		collectable.setup(item)
		collectable.global_position = global_position
		scene.add_child(collectable)
		
		collectable.drop(loot_radius)



################# ################# #################
################# STRUCTURE_MANAGER #################
################# ################# #################

## Prepare the structure to place, helpful to separate the NPC vs Player's methods
func prepare_structure(structure: StringName, scene: Node2D):
	if curr_structure:
		# INFO - If the previous one was never placed/used, remove it to clean memory:
		if not curr_structure.get_parent():
			curr_structure.queue_free()
			reset_saved_structure()
	if ItemManager.has_resource(structure):
		curr_structure = ItemManager.get_resource(structure).instantiate()
		curr_area = curr_structure.find_child("StructureArea").duplicate()
		curr_structure.find_child("StructureArea").queue_free()
		scene.add_child.call_deferred(curr_area)
		curr_area.set_owner.call_deferred(scene)
		## TODO ATTENTION - I MUST call .queue_free after removing childs everywhere, for memory


## TBD - I think I got a better idea to avoid this thread issue:
## 1. A threaded function that runs the loop for 50 random Vector2 positions 
## just as I already have it pretty much.
## 2. Send a signal that runs a function in the main thread, moving those areas
## to their respective spots, a O(50) loop, can lower the size to 7 attempts
## 3. Run another threaded function that checks the overlaps of those areas,
## then returns false or true if it finds the spot, which should simply be assigned at some point 
## Verifies if the structure's area is not overlapping with something it shouldn't
func verify_structure_area(global_position: Vector2):# -> bool:
	if curr_area:
		var callable = Callable(self, "verify_structure_overlap")
		callable.call_deferred(global_position)
		#curr_area.call_deferred("set_global_position", global_position) # global_position = global_position  ## FIXME - Final boss bug, for using multithreading
		#curr_area.global_position = global_position # global_position = global_position  ## FIXME - Final boss bug, for using multithreading
		### I cannot interact with properties like global_position on another thread. None of this works.
		#if not curr_area.has_overlapping_bodies(): # Not working well
			#return true
	#print("OVERLAP !!! ============================")
	#return false


func verify_structure_overlap(global_position: Vector2):# -> bool:
	curr_area.global_position = global_position
	if not curr_area.has_overlapping_bodies(): # FIXME - Not working well
		print("SUCCESS !!! ############################## ", curr_area.monitorable)
		SignalManager.search_done.emit(global_position)
		#return true
	else:
		print("OVERLAP !!! ============================")
	#return false


## Places the structure in the given global_position and adds it to the scene
## TODO - Maybe place it somewhere that makes sense, for future management
## Somewhere I can easily loop through in my remastered LevelComponent
func place_structure(global_position: Vector2, scene: Node2D):
	curr_area.queue_free()
	scene.add_child(curr_structure)  # Must run first, or global_position'll be nuts (The Void's)
	curr_structure.global_position = global_position
	print("Placed item at = ", curr_structure.global_position)
	reset_saved_structure()


## Resets the current saved structure and area, not delete from memory
func reset_saved_structure():
	curr_structure = null
	curr_area = null
