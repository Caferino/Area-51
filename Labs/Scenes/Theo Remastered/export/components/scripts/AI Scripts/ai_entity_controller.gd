class_name AIEntityController extends EntityController

@export var entity      : Entity      ## The entity itself, for data access.
@export var context_map : ContextMap  ## The entity's "eyes".

var enemy_distance_tolerance : float = 50
var time_accumulator         : float = 0.0
var current_target           : Node  = null
var is_idle                  : bool  = false
var is_busy                  : bool  = false
var is_chasing               : bool  = false
var is_stunned               : bool  = false
var is_enemy_nearby          : bool  = false
