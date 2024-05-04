extends Node

@export_node_path var item_in_hand_path
@onready var item_in_hand_node = get_node(item_in_hand_path) as Control
@export_node_path var item_info_path
@onready var item_info = get_node(item_info_path) as Control

var inventories : Array = []
var item_in_hand = null
var item_offset = Vector2.ZERO


func _ready():
	SignalManager.connect("inventory_ready", _on_inventory_ready)


func _on_inventory_ready(inventory):
	inventories.append(inventory)
	
	for slot in inventory.slots:
		slot.connect("mouse_entered", _on_mouse_entered_slot.bind(slot))
		slot.connect("mouse_exited", _on_mouse_exited_slot)
		slot.connect("gui_input", _on_gui_input_slot.bind(slot))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and item_in_hand:
		item_in_hand.position = event.position - item_offset


func _on_mouse_entered_slot(slot):
	if slot.item:
		item_info.display(slot)


func _on_mouse_exited_slot():
	item_info.hide()


func _on_gui_input_slot(event: InputEvent, slot: InventorySlot):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if item_in_hand:
			item_in_hand_node.remove_child(item_in_hand)
			
			if slot.item:
				var temp_item = slot.item
				slot.pick_item()
				temp_item.global_position = event.global_position - item_offset
				slot.put_item(item_in_hand)
				item_in_hand = temp_item
				item_in_hand_node.add_child(item_in_hand)
			else:
				slot.put_item(item_in_hand)
				item_in_hand = null
		elif slot.item:
			item_in_hand = slot.item
			item_offset = event.global_position - item_in_hand.global_position
			slot.pick_item()
			item_in_hand_node.add_child(item_in_hand)
			item_in_hand.global_position = event.global_position - item_offset
