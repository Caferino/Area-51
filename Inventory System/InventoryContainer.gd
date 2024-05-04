extends UIWindow

@export_node_path var inventory_container_path
@onready var inventory_container = get_node(inventory_container_path) as Control

var current_inventories : Array = []

func _ready() -> void:
	SignalManager.connect("inventory_opened", _on_inventory_opened)


func close():
	for i in current_inventories:
		inventory_container.remove_child(i)
	
	current_inventories = []
	hide()


func _on_inventory_opened(inventory: Inventory):
	if current_inventories.size() == 0:
		size.y = 55
	
	if current_inventories.has(inventory):
		return
	
	inventory_container.add_child(inventory)
	current_inventories.append(inventory)
	size.y += inventory.size.y + inventory_container.get_theme_constant("Separation")
	show()


func _on_close_button_pressed() -> void:
	close()
