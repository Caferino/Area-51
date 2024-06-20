class_name HumanoidMovementComponent extends EntityMovement
## The humanoid entity's [color=salmon]muscles.

var weapon_on_left_hand : bool    = true           ## Boolean for the weapon's position.


## Rotates the weapon and animates the attack.
func attack(weapon: Weapon, torso_animator: AnimationPlayer, head_animator: AnimationPlayer):
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
	
	if last_direction.x < 0:                                 ## LEFT
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
