class_name InteractableComponent extends Node2D
## The entity's [color=rose]interaction area.

@export var interactable : Node2D = null  ## The interactable structure, entity or object.

func interact(item: String = ""):  ## TODO - Maybe make item a class
	get_parent().interact(item)
