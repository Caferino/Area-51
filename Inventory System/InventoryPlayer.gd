extends UIWindow

@export_node_path var inventory_path
@onready var inventory = get_node(inventory_path) as Inventory


func _ready():
	size.y = 55 + inventory.size.y
