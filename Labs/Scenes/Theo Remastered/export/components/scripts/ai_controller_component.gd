class_name AIControllerComponent extends EntityController
## The entity's being controlled by an [color=violet]AI.

signal player_move()      ## Emitted whenever the player gives movement input ([kbd]'W' 'A' 'S' 'D'[/kbd]).
signal player_sprint()    ## Emitted whenever the player gives sprinting input ([kbd]'Shift'[/kbd]).
signal player_attack()    ## Emitted whenever the player gives attack input ([kbd]Left-Click[/kbd]).
signal player_interact()  ## Emitted whenever the player gives interact input ([kbd]'F'[/kbd]).

@export var interactor_area     : Area2D         ## The interactor's monitoring area.
@export var interactor_animator : AnimationTree  ## The interactor's animator (for rotation).

var dir              : Vector2  = Vector2()  ## Current direction.
var anim_state       : String   = "Move"     ## Current animation state.
var is_attacking     : bool     = false      ## Is the entity currently attacking?
var is_sprinting     : bool     = false      ## Is the entity currently sprinting?
var is_moving        : bool     = false      ## Is the entity currently moving?

## New
var is_enemy_nearby  : bool     = false      ## Is any enemy close?
var is_chasing       : bool     = false      ## Currently chasing anything?
var current_target   : Node     = null       ## The entity's current target.
## Might move these to the human NPC's stats themselves
var enemy_distance_tolerance : float   = 50


## Rotates the interactor's [member Marker2D.rotation].
func rotate_interactor(direction: Vector2):
	interactor_animator["parameters/Movement/blend_position"] = direction


func on_move():
	pass


func on_stop():
	is_moving = false


func on_attack():
	is_attacking = true


func on_attack_finished():
	is_attacking = false


func on_sprint():
	pass


func _on_vision_area_body_entered(target: Node2D) -> void:
	if target.is_in_group("Player"):
		is_enemy_nearby = true
		current_target = target


func _on_vision_area_body_exited(target: Node2D) -> void:
	if target.is_in_group("Player"):
		is_enemy_nearby = false
		current_target = null
