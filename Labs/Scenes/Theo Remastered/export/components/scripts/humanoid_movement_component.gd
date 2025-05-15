class_name HumanoidMovementComponent extends EntityMovement
## The humanoid entity's [color=salmon]muscles.

var weapon_on_left_hand : bool = true           ## Boolean for the weapon's position.


## Rotates the weapon and animates the attack.
func attack(weapon: MeleeWeapon, torso_animator: AnimationPlayer, head_animator: AnimationPlayer):
	if last_direction.y < 0:                                 ## UP
		weapon.position = Vector2(0, -10)
		weapon.rotation_degrees = -90
		if weapon_on_left_hand:
			torso_animator.play("attack_up")
			head_animator.play("attack_up")
			weapon.get_child(1).play("attack_right")
		else:
			torso_animator.play_backwards("attack_up")
			head_animator.play_backwards("attack_up")
			weapon.get_child(1).play("attack_left")
	elif last_direction.y > 0:                               ## DOWN
		weapon.position = Vector2(0, 5)
		weapon.rotation_degrees = 90
		if weapon_on_left_hand:
			torso_animator.play("attack_down")
			head_animator.play("attack_down")
			weapon.get_child(1).play("attack_right")
		else:
			torso_animator.play_backwards("attack_down")
			head_animator.play("attack_down")
			weapon.get_child(1).play("attack_left")
	elif last_direction.x < 0:                                 ## LEFT
		weapon.position = Vector2(-5, 0)
		weapon.rotation_degrees = 180
		if weapon_on_left_hand:
			torso_animator.play("attack_left")
			head_animator.play_backwards("attack_left")
			weapon.get_child(1).play("attack_right")
		else:
			torso_animator.play_backwards("attack_left")
			head_animator.play("attack_left")
			weapon.get_child(1).play("attack_left")
	elif last_direction.x > 0:                               ## RIGHT
		weapon.position = Vector2(5, 0)
		weapon.rotation_degrees = 0
		if weapon_on_left_hand:
			torso_animator.play_backwards("attack_right")
			head_animator.play_backwards("attack_right")
			weapon.get_child(1).play("attack_right")
		else:
			torso_animator.play("attack_right")
			head_animator.play("attack_right")
			weapon.get_child(1).play("attack_left")
	
	weapon_on_left_hand = !weapon_on_left_hand


func gather(tool: GatheringTool, torso_animator: AnimationPlayer, head_animator: AnimationPlayer):
	if last_direction.y < 0:                                 ## UP
		torso_animator.play("gather_up")
		head_animator.play("gather_up")
		tool.get_child(2).play("gather_up")
	elif last_direction.y > 0:                               ## DOWN
		torso_animator.play("gather_down")
		head_animator.play("gather_down")
		tool.get_child(2).play("gather_down")
	elif last_direction.x < 0:                                 ## LEFT
		torso_animator.play("gather_left")
		head_animator.play("gather_left")
		tool.get_child(2).play("gather_left")
	elif last_direction.x > 0:                               ## RIGHT
		torso_animator.play("gather_right")
		head_animator.play("gather_right")
		tool.get_child(2).play("gather_right")
