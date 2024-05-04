class_name InventorySlot extends TextureRect

@export_node_path var item_container_path
@onready var item_container = get_node(item_container_path) as Control

var item : ItemDisplay

func _ready() -> void:
	if item:
		item_container.add_child(item)


func set_item(new_item):
	item = new_item


func pick_item():
	item.pick_item()
	item_container.remove_child(item)
	item = null


func put_item(new_item):
	item = new_item
	item.put_item()
	item_container.add_child(item)
