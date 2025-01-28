@icon("res://Labs/Assets/X. Other/Icons/context_map.svg")
class_name ContextMap extends Node2D
## The entity's [color=purple]Context Map.

@export var pers_space : Area2D             = null  ## The entity's personal space.
@export var controller : AIEntityController = null  ## The entity's AI Controller.

signal chosen_dir_updated()

# WARN - prob only works at ready or every frame
var space_state    : PhysicsDirectSpaceState2D = null  ##
var chosen_dir     : Vector2          = Vector2.ZERO   ##
var ray_directions : Array[Vector2]   = []    ## The raycasts that detect collisions. 
var interest       : Array[float]     = []    ## Interest values array of size total_rays.
var danger         : Array[float]     = []    ## Danger values array of size total_rays.
var total_rays     : int              =    8  ## Total rays. Lower = faster, but less accurate.
var look_ahead     : float            = 25.0  ## Must be bigger than the aware_zone area.
var added_interest : float            =  5.0  ## A default value for interest/danger calculations.
## TODO - Make enable_layers unique per entity, not everyone sees the same thing
var enable_layers  : int              = 134221921  ## Decimal bitmask for layers 1, 6, 7, 13 & 28.

## ATTENTION - enable_layers can be problematic if it sees itself. Danger all the time

## TBD - I think the avoidance of obstacles, like in chop_tree at GOAP AI,
## should or could be done here by adding interest to the vector closest to the
## target. But be careful to measure this well somehow, not big numbers, 
## or it will get stuck.

## Generates the rays.
func _ready():
	ray_directions.resize(total_rays)
	interest.resize(total_rays)
	danger.resize(total_rays)
	
	for i in total_rays:
		var angle = i * 2 * PI / total_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)


## It has to be in physics because a PhysicsRay2D is created inside the loop.
func _physics_process(_delta):
	situational_awareness()


## TODO - Fear factor? A variable to further influence the Utility Agent's decisions?
func situational_awareness():
	if $AwareZoneArea.get_overlapping_bodies():
		if controller.chasing:
			if controller.enemy_too_close:
				chosen_dir = _handle_context()
			else:
				chosen_dir = controller.dir
		else:
			
			chosen_dir = _handle_context()
	else:
		chosen_dir = controller.dir
	
	chosen_dir_updated.emit()


## Calculates interest and danger per ray, influenced by the environment.
## TODO - I remember trying using 8 rays instead of creating the query here.
## Forgot what went wrong. Might refactor this, and return chosen_dir only,
## leave the normalize() calculation to the function calling context_map.chosen_dir
func _handle_context() -> Vector2:
	for i in total_rays:
		## Interest
		interest[i] = max(1, ray_directions[i].dot(transform.x))
		
		## Danger
		space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, 
			global_position + ray_directions[i] * look_ahead, enable_layers)
		var result = space_state.intersect_ray(query)
		danger[i] = 1.0 if result else 0.0
		
		## Direction
		var half_rays = total_rays/2  # In case total_rays changes during gameplay
		if danger[i] > 0.0:
			if i > half_rays:
				interest[i - half_rays - 1] = added_interest
			else:
				interest[i + half_rays - 1] = added_interest
			interest[i] = 0.0
		chosen_dir += ray_directions[i] * interest[i]
	
	return chosen_dir.normalized()
