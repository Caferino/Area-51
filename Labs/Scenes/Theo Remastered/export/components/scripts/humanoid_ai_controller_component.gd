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
	pass


func on_stop():
	moving = false


func on_attack():
	attacking = true


func on_attack_finished():
	attacking = false


func on_sprint():
	pass


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


func _on_received_order(order : int) -> void:
	print("Human says: Working on it!")
	if order == 0:
		# Turn BT off and GOAP on inside here or outside?
		# NOTE - Had the idea of having GOAP give the big tree's center coords as a dir
		# for now, keep it super simple just to test if the switching off/on works well,
		# as well as some basic movement given to the brain, the AI of this entity.
		ai_behavior_tree.disable()
		ai_goap.enable()
		## WARN TODO - The switch back will be done later, somewhere
		print("Building a firepit! Planning...")
	elif order == 1:    ## WARN - Delete/Edit, these are just dummy example fillers
		print("Doing something else! Planning...")
	else:
		pass
