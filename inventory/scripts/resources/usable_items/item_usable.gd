class_name ItemUsable extends Resource

signal start_cooldown(item_usable)
signal cooldown_tick(cooldown_remaining)
signal can_use_changed(can_use)

var unlimited_use = false
var cooldown = 1
var cooldown_remaining = 0
var is_in_cooldown = false
var can_use = false
var can_always_use = false
var on_use_text = ""
var condition = ""

var item : Item


func _init(data, parent_item):
	item = parent_item
	set_data(data)
	SignalManager.inventory_group_content_changed.connect(_on_inventory_group_content_changed)


## Set the base data
func set_data(data):
	if data.has("unlimited_use"): unlimited_use = data.unlimited_use
	if data.has("cooldown"): cooldown = data.cooldown


## Check if the item is usable
func is_usable() -> bool:
	return (can_use or can_always_use) and item.is_on_player()


## Use the item if possible and start the cooldown if there is one
func use():
	if is_usable() and not is_in_cooldown:
		execute()
		
		if not unlimited_use:
			item.quantity -= 1
		
		is_in_cooldown = true
		cooldown_remaining = cooldown
		SignalManager.cooldown_started.emit(self)


## Execute the effect of the usable item
## Must be implemented on the inherited script
func execute():
	pass


## Get the text to display to show the effect
## Must be implemented on the inherited script
func get_use_text():
	pass


## TODO - Add lines in the item info
func set_info(item_info):
	item_info.add_splitter()
	item_info.add_line(ItemInfoLine.new("On use:", GameEnums.RARITY.NORMAL))
	item_info.add_line(ItemInfoLine.new(get_use_text(), item.rarity))
	item_info.add_line(ItemInfoLine.new("Condition:", GameEnums.RARITY.NORMAL))
	item_info.add_line(ItemInfoLine.new(condition, item.rarity))


## Return the use function (To be added in the item action)
func get_action():
	return {
		name = "Use",
		function = use
	}


func _on_inventory_group_content_changed(groups):
	if groups.has("player"):
		can_use_changed.emit(is_usable())
