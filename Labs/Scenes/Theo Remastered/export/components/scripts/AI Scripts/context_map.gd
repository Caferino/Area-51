@icon("res://Labs/Assets/X. Other/Icons/context_map.svg")
class_name ContextMap extends Node2D

@export var controller : AIEntityController = null
@export var pers_space : Area2D = null

signal chosen_dir_updated()

# WARN - prob only works at ready or every frame
var space_state    : PhysicsDirectSpaceState2D = null 
var chosen_dir     : Vector2          = Vector2.ZERO
var ray_directions : Array[Vector2]   = []
var interest       : Array[float]     = []
var danger         : Array[float]     = []
var total_rays     : int              =    8
var look_ahead     : float            = 50.0   ## Must be bigger than the aware_zone area.
var added_interest : float            =  5.0
var enable_layers  : int              = 4161   ## Decimal collision_bitmask for layers 1, 7 and 13.
var overlap_bodies : bool             = false

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
	if overlap_bodies:
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
		if danger[i] > 0.0:
			if i > total_rays/2:
				interest[i - (total_rays/2) - 1] = added_interest
			else:
				interest[i + (total_rays/2) - 1] = added_interest
			interest[i] = 0.0
		chosen_dir += ray_directions[i] * interest[i]
	
	return chosen_dir.normalized()


func _on_aware_zone_area_body_entered(_body: Node2D) -> void:
	overlap_bodies = true


func _on_aware_zone_area_body_exited(_body: Node2D) -> void:
	if not $AwareZoneArea.get_overlapping_bodies():
		overlap_bodies = false
