class_name Spawner extends Node
## An entity [color=lime]spawner.

@export var enabled : bool = false

var radius   : float = 50.0
var pool     : Array = ["Human"]  ## TODO - Should be dynamic, start empty and be filled by sm else
## That something else could be a kind of level manager, scene manager, sequence, mission, WIP


## WIP 
func _ready():
	if enabled:
		spawn_random()


## Spawns a random entity from its pool.
func spawn_random(_position: Vector2 = Vector2(0,0)):
	var entity = Caferino.spawn(pool[0])
	add_child(entity)
	## TODO ! Call the corresponding manager to summon from the entities pool
