class_name InteractableArea extends Area2D
## DEPRECATED

@export var parent : Marker2D


func interact(item: String = ""):  ## TODO - Make item a class
	parent.interact(item)
