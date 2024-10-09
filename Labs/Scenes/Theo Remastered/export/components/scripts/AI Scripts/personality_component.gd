class_name PersonalityComponent extends Node

var roles : Array[PersonalityRole] = []

func _ready() -> void:
	for role in get_children():
		roles.append(role)
