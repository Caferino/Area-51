class_name GatheringTool extends Tool
## Nature's worst nightmare.


## Prepares the tool by hiding it and updating its speed stat from a database.
func _ready():
	area.monitoring = false
	sprite.texture  = attributes.texture
	animator.speed_scale = attributes.speed


func _on_tool_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("GatheringNode"):
		area.get_parent().interact(attributes.type)
