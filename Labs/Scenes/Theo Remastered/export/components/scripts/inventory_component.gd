class_name InventoryComponent extends Node2D
## The entity's [color=blue]body.

signal inventory_change()  ## Emits whenever something meaningful happens in the inventory.

var inventory : Dictionary = {  ## The entity's inventory.
	"Logs" : 0
}   
var size : int = 5


## WIP
func _ready() -> void:
	## TODO - Load inventory from memory/save? (Much, much later)
	pass


func add_item():
	pass


func drop_item():
	pass


func has_item(_item : String):
	pass


func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Collectable"):
		area.pick_up()
		inventory[area.item_name] += area.item_qty
		#print(inventory[area.item_name])   DEBUG
