class_name PersonalityComponent extends Node
## The entity's personality.

var roles : Array[PersonalityRole] = []  ## A personality is composed of roles.

# Loads well-known or custom-made roles like lumberjack, miner, crafter, guard...
func _ready() -> void:
	for role in get_children():
		roles.append(role)
