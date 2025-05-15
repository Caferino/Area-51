class_name InteractableComponent extends Node2D
## The entity's [color=rose]interaction area.

@export var interactable : Node2D = null  ## The interactable structure, entity or object.

## NOTE - Might be useless if interactable takes you straight to the parents
func interact(item: GameEnums.TOOL_TYPE):  ## TODO - Maybe make item a class
	interactable.interact(item)
