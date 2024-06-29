class_name EntityController extends Node2D
## Main class for controllers. Might serve no purpose other than its type.

signal entity_move()      ## Emitted whenever the entity gives movement input ([kbd]'W' 'A' 'S' 'D'[/kbd]).
signal entity_sprint()    ## Emitted whenever the entity gives sprinting input ([kbd]'Shift'[/kbd]).
signal entity_attack()    ## Emitted whenever the entity gives attack input ([kbd]Left-Click[/kbd]).
signal entity_interact()  ## Emitted whenever the entity gives interact input ([kbd]'F'[/kbd]).

var dir        : Vector2  = Vector2()  ## Current direction.
var anim_state : String   = "Idle"     ## Current animation state.
var attacking  : bool     = false      ## Is the entity currently attacking?
var sprinting  : bool     = false      ## Is the entity currently sprinting?
var moving     : bool     = false      ## Is the entity currently moving?
