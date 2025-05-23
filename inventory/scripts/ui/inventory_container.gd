extends UIWindow

var current_inventory


func _ready():
	super()
	SignalManager.inventory_opened.connect(_on_inventory_opened)
	SignalManager.inventory_closed.connect(_on_inventory_closed)


## Remove the inventory node when closed
func close():
	for c in %inventory_container.get_children():
		c.queue_free()
	current_inventory = null
	hide()


## When an inventory is opened, display it in the panel
func _on_inventory_opened(inventory: Inventory):
	if current_inventory == inventory:
		return
	
	var node = AlcarodianResourceManager.get_instance("inventory_node")
	%inventory_container.add_child(node)
	node.inventory = inventory
	current_inventory = inventory
	show()


func _on_inventory_closed(_inventory: Inventory):
	close()
