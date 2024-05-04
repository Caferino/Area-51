class_name Chest extends Button


@export var chest_size: int = 1
@export var inventory_name: String
@export var items: Array

var inventory : Inventory


func _init() -> void:
	inventory = preload("res://Labs/Scenes/Collectable Items & Inventory/New Inventory System 1.0/Inventory/Inventory System/Inventory.tscn").instantiate()

func _ready() -> void:
	inventory.set_inv_size(chest_size)
	inventory.inventory_name = inventory_name
	set_items()


func set_items():
	for i in items:
		inventory.add_item(ItemManager.get_item(i))


func _on_pressed() -> void:
	SignalManager.emit_signal("inventory_opened", inventory)
