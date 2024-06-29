class_name AIEntityController extends EntityController

@export var entity      : Entity      ## The entity itself, for data access.
@export var context_map : ContextMap  ## The entity's "eyes".

var distance_tolerance : float = 50
var time_accumulator   : float = 0.0
var iterations         : int   = 0
var idle               : bool  = false
var wandering          : bool  = false
var chasing            : bool  = false
var fleeing            : bool  = false
var stunned            : bool  = false
var in_combat          : bool  = false
var enemy_nearby       : bool  = false
var enemy_too_close    : bool  = false

var current_target     : Node   = null  ## Targets entities, interactables or goals.
var current_action     : String = "Idle"
