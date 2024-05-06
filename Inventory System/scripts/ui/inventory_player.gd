extends UIWindow

@export var player_data: PlayerData


## Draw the player's inventories from the player's data
func _ready():
	super()
	var equipment_panel = AlcarodianResourceManager.get_instance("equipment_node")
	var inventory_left_panel = AlcarodianResourceManager.get_instance("inventory_node")
	var inventory_right_panel = AlcarodianResourceManager.get_instance("inventory_node")
	%inventory_container.add_child(equipment_panel)
	%inventory_container.add_child(inventory_left_panel)
	%inventory_container.add_child(inventory_right_panel)
	equipment_panel.inventory = player_data.equipment
	inventory_left_panel.inventory = player_data.inventory_left
	inventory_right_panel.inventory = player_data.inventory_right




































