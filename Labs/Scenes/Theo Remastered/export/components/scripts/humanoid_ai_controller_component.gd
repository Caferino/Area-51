@icon("res://Labs/Assets/X. Other/Icons/brain.svg")
class_name HumanoidAIControllerComponent extends AIEntityController
## The entity's being controlled by an [color=violet]AI.

@export var interactor_area      : Area2D         ## The interactor's monitoring area.
@export var interactor_animator  : AnimationTree  ## The interactor's animator (for rotation).
@export var vision_area          : Area2D         ## The entity's field of view.
@export var vision_area_animator : AnimationTree  ## The entity's vision area animator.

@export var personality          : PersonalityComponent
@export var ai_behavior_tree     : BeehaveTree    ## The Humanoid's Behavior Tree AI (cheaper CPU).
@export var ai_goap              : HumanAiGoap    ## The humanoid's Goal-Oriented Action Planner AI.


func _ready() -> void:
	SignalManager.entity_order.connect(_on_received_order)
	ai_goap.setup()


## Rotates the interactor's [member Marker2D.rotation].
func rotate_interactor(direction: Vector2):
	interactor_animator["parameters/Movement/blend_position"] = direction
	vision_area_animator["parameters/Movement/blend_position"] = direction


func on_move():
	anim_state = "Move"
	moving = true
	sprinting = false


func on_sprint():
	anim_state = "Run"
	moving = true
	sprinting = true


func on_stop():
	## ATTENTION - I am using LERP for the entity's movement velocity, which
	## gives it a very tiny eased-out ending, that is, the last milliseconds
	## after releasing the key, the velocity is near zero, not zero instantly.
	## It gives a very tiny slide effect that is hard to notice, but it adds 
	## to the feel of realism and gameplay after rigurous testing.
	## It is a problem because anim_state takes under a second to update if
	## I want to change it here, which makes the entity seem like it is still
	## walking when it visibly is not moving anymore.
	anim_state = "Idle"
	moving = false
	sprinting = false


func on_attack():
	attacking = true


func on_attack_finished():
	attacking = false


func _on_vision_area_body_entered(target: Node2D) -> void:
	if target.is_in_group("Player"):
		enemy_nearby = true
		current_target = target
		SignalManager.in_entity_vision_area.emit(true)


func _on_vision_area_body_exited(target: Node2D) -> void:
	if target.is_in_group("Player"):
		enemy_nearby = false
		current_target = null
		SignalManager.in_entity_vision_area.emit(false)


## WIP - The entity receives an order to accomplish with a GOAP AI System.
func _on_received_order(order : int) -> void:
	if order == 0:   ## Build a firepit
		## TODO - Plans/Goals/Orders like these can be made into modules someday
		ai_goap.states["has_firepit_priority"] = 10   # Setup GOAP
		ai_goap.states["need_wood"] = 3
		dir = Vector2.ZERO                            # Stop the entity
		on_stop()
		switch_ai()
		## TODO - The switch back will be done later, somewhere
	elif order == 1:    ## WARN - Placeholders
		print("Doing something else! Planning...")
	else:
		pass


## Switches between GOAP and BTR AI Systems.
func switch_ai():
	if ai_goap._enabled:
		ai_goap.disable()
		ai_behavior_tree.enable()
	else:
		ai_goap.enable()
		ai_behavior_tree.disable()
