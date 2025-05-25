class_name EntityController extends Node2D
## Main class for controllers. Might serve no purpose other than its type.

signal entity_roll()      ## Emitted whenever the entity gives roll input ([kbd]'Space'[/kbd]).
signal entity_move()      ## Emitted whenever the entity gives movement input ([kbd]'W' 'A' 'S' 'D'[/kbd]).
signal entity_sprint()    ## Emitted whenever the entity gives sprinting input ([kbd]'Shift'[/kbd]).
signal entity_attack()    ## Emitted whenever the entity gives attack input ([kbd]'Left-Click'[/kbd]).
signal entity_gather()    ## Emitted whenever the entity gives gather input ([kbd]'G'[/kbd]).
signal entity_interact()  ## Emitted whenever the entity gives interact input ([kbd]'F'[/kbd]).

var dir         : Vector2  = Vector2()  ## Current direction.
var anim_state  : String   = "Idle"     ## Current animation state.
var attacking   : bool     = false      ## Is the entity currently attacking?
var sprinting   : bool     = false      ## Is the entity currently sprinting?
var moving      : bool     = false      ## Is the entity currently moving?
var swimming    : bool     = false      ## Is the entity currently in deep water?
var rolling     : bool     = false      ## Is the entity currently rolling?
var gathering   : bool     = false      ## Is the entity currently gathering?
var aiming      : bool     = false      ## Currently aiming or selecting a spot?
var obj_in_hand : Node2D   = null       ## Object/Spell currently held in hand.
var speakers    : Array    = []         ## Near a speaker the player can talk to.
var is_talking  : bool     = false      ## To stop moving while talking.
