class_name InteractableComponent extends Node2D
## The entity's [color=rose]interaction area.

func interact(item: String = ""):  ## TODO - Make item a class
	get_parent().interact(item)
