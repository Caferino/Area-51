class_name Limb extends Node
## A body's [color=orange]limb.

@export var accessories     : AccessoriesComponent  ## The limb's [class AccessoriesComponent].
@export var animator_tree   : AnimationTree         ## The limb's [class AnimationTree].
@export var animator        : AnimationPlayer       ## The limb's [class AnimationPlayer].


func _on_limb_area_entered(area: Area2D) -> void:
	get_parent().limb_interact.emit(true, self.name, area)


func _on_limb_area_exited(area: Area2D) -> void:
	get_parent().limb_interact.emit(false, self.name, area)
