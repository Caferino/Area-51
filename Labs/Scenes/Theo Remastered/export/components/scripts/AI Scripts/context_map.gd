class_name ContextMap extends Node2D

# WARN - prob only works at ready or every frame
var space_state    : PhysicsDirectSpaceState2D = null 
var chosen_dir     : Vector2          = Vector2.ZERO
var ray_directions : Array[Vector2]   = []
var interest       : Array[float]     = []
var danger         : Array[float]     = []
var total_rays     : int              = 8
var look_ahead     : float            = 50.0   ## Must be bigger than the aware_zone area.
var added_interest : float            =  5.0
var enable_layers  : int              = 4161   ## Decimal collision_bitmask for layers 1, 7 and 13.

## Generates the rays.
func _ready():
	ray_directions.resize(total_rays)
	interest.resize(total_rays)
	danger.resize(total_rays)
	
	for i in total_rays:
		var angle = i * 2 * PI / total_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)


func _physics_process(_delta):
	if $AwareZoneArea.get_overlapping_bodies():
		_handle_context()


func _handle_context():
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
	
	chosen_dir = chosen_dir.normalized()
