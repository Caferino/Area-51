extends Control


@onready var inv: Inv = preload("res://Labs/Scenes/Collectable Items & Inventory/Inventory/playerinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready():
	update_slots()
	close()


func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])


func _process(_delta):
	if Input.is_action_just_pressed("open_inventory"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true


func close():
	visible = false
	is_open = false
