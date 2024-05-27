class_name BodyComponent extends Node2D

signal limb_interact(entered, area)

var gear = {}
var limbs = {}


func _ready() -> void:
	connect_limbs()


func connect_limbs():
	for limb in get_children():
		if limb is Limb:
			limbs[limb.name] = limb
		else:
			for equipment in limb.get_children():
				gear[equipment.name] = equipment


## Left Left
func _on_left_leg_area_area_entered(area: Area2D) -> void  : limb_interact.emit(true, "left_leg", area)
func _on_left_leg_area_area_exited(area: Area2D) -> void   : limb_interact.emit(false, "left_leg", area)

## Right Leg
func _on_right_leg_area_area_entered(area: Area2D) -> void : limb_interact.emit(true, "right_leg", area)
func _on_right_leg_area_area_exited(area: Area2D) -> void  : limb_interact.emit(false, "right_leg", area)
