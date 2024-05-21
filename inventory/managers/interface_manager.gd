extends Node

func validate(node):
	for interface in node.interfaces:
		if interface != null:
			var instance = interfaces[interface]
			for method in instance.get_script_method_list():
				assert(node.has_method(method.name), "Interface Error: " + node.name
				+ " does not possess the '" + method.name + "()' method.")


@onready var interfaces = {
	GameEnums.INTERFACE.DAMAGEABLE : preload("res://inventory/managers/interfaces/damageable.gd"),
	GameEnums.INTERFACE.FLAMMABLE  : preload("res://inventory/managers/interfaces/flammable.gd")
}
