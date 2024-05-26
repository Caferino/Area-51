class_name BodyComponent extends Node2D

signal limb_interact(limb, object)

var limbs = {}

var gear = {}


func _ready() -> void:
	connect_limbs()


func connect_limbs():
	for limb in get_children():
		if limb is Limb:
			limbs[limb.name] = limb
		else:
			for equipment in limb.get_children():
				gear[equipment.name] = equipment
