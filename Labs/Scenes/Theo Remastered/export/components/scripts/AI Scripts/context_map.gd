extends Node2D

var ray_directions: Array[RayCast2D] = []  ## Array of raycasts.


## Registers the rays.
func _ready():
	for ray in get_children():
		ray_directions.insert(ray_directions.size(), ray)
