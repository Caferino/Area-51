class_name Field extends Node2D
## A plants [color=green]field.

@export var amount : int   = 0
@export var plants : Array = []
@onready var area_size = $Area.get_shape().size


## Generates an amount of plants within its area's shape boundaries.
## TODO - I tried multithreading and failed, but what about now that I am more trained?
## Remember to add_child and set_owner to the level before dealing with global_position.
## Remember that has_overlapping_bodies and such might not work well with multithreading, only signals.
func _ready():
	var area_size_x = area_size.x / 2
	var area_size_y = area_size.y / 2
	for n in amount:
		var plant = Bizck.create_plant(plants.pick_random(), false, true)
		var rand_x = randf_range(global_position.x - area_size_x + plant.margin_x, global_position.x + area_size_x - plant.margin_x)
		var rand_y = randf_range(global_position.y - area_size_y + plant.margin_y, global_position.y + area_size_y - plant.margin_y)
		
		add_child(plant)
		plant.global_position = Vector2(rand_x, rand_y)
