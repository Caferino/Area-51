class_name BodyComponent extends Node2D
## The entity's [color=blue]body.

signal limb_interact(entered: bool, limb_name: String, area: Area2D)  ## Emits whenever a limb touches something.

var limbs : Dictionary = {}   ## The entity's body limbs of type [Limb].
var gear  : Dictionary = {}   ## The entity's usable equipment, like swords and tools, etc.


## Stores the body's limbs and equipment inside 
## [member BodyComponent.limbs] and [member BodyComponent.gear].
func _ready() -> void:
	## Connect the limbs
	for limb in get_children():
		if limb is Limb:
			limbs[limb.name] = limb
		else:
			for equipment in limb.get_children():
				gear[equipment.name] = equipment
