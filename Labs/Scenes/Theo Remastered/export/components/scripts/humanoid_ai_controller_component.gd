class_name HumanoidAIControllerComponent extends AIEntityController
## The entity's being controlled by an [color=violet]AI.

@export var interactor_animator_tree : AnimationTree  ## The interactor's animator (for rotation).

## Rotates the interactor's [member Marker2D.rotation].
func rotate_interactor(direction: Vector2):
	interactor_animator_tree["parameters/Movement/blend_position"] = direction


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


func _on_vision_area_body_exited(target: Node2D) -> void:
	if target.is_in_group("Player"):
		enemy_nearby = false
		current_target = null
