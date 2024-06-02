class_name HumanoidMovementComponent extends Node
## The entity's [color=salmon]muscles.

signal stopped_moving()  ## Emits whenever the entity stops moving.

var last_direction      : Vector2 = Vector2(0, 1)  ## Entity's last faced direction.
var weapon_on_left_hand : bool    = true           ## Boolean for the weapon's position.
var is_moving           : bool    = false          ## Is the player currently moving?


## Handles the [param entity]'s movement.
## [br][br]
## Checks the direction of the Player/AI's input first, then uses the entity's 
## stamina_stats to calculate the [member CharacterBody2D.velocity] and the 
## [member AnimationPlayer.speed_scale].
## [br][br]
## This is where [method CharacterBody2D.move_and_slide] resides.
func handle_movement(entity: Human, direction: Vector2, is_sprinting: bool):
	var accel = 0.12  ## Lower for "walking on ice" effect, it'd need DEACCEL, done below
	if direction != Vector2.ZERO:
		if is_sprinting:
			direction *= entity.stamina_stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED]
		else:
			direction *= entity.stamina_stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED]
	else:
		accel = 0.33  ## Reduce for DEACCEL effect
	
	entity.velocity = entity.velocity.lerp(direction, accel)
	entity.move_and_slide()
	
	# This block prevents the entire animation process from running every physics frame unnecessarily
	if entity.velocity.is_zero_approx() and entity.velocity != Vector2.ZERO:
		entity.velocity = Vector2.ZERO
		stopped_moving.emit()
		handle_animation(entity)
	elif entity.velocity != Vector2.ZERO: 
		handle_animation(entity)


## Handles the [param entity]'s animation.
## [br][br]
## Checks whether the entity has gone idle or is walking/running. It uses the
## following formula to calculate the [member AnimationPlayer.speed_scale]:
## [codeblock]
## if current_state == "Run":
##     speed_scale = (entity.stamina_stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED] - 60) / 60 + 1.8
## else:
##     speed_scale = (entity.stamina_stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED] - 60) / 60 + 1.8
## [/codeblock]
## The default speed_scale value of 1.0 felt too slow for the entity's movement.
## A value between 1.8 - 2.0 provides a more snappy and arcade feel.
## The subtraction and division by 60 adjust the entity's speed to an appropriate
## range for the [member AnimationPlayer.speed_scale].
## Example: If the character's move speed is 60px/s, its speed_scale is equal to 1.8.
## [br]
## It updates the [member Human.body_pose] of the entity and then calls
## [method move_body] to execute the assigned values on the actual animation nodes.
func handle_animation(entity: Human):
	var current_state = entity.controller.anim_state
	var speed_scale   = 1.0
	var direction     = entity.controller.dir
	if direction == Vector2.ZERO:
		current_state = "Idle"
	else:
		last_direction = direction
		if current_state == "Run":
			speed_scale = (entity.stamina_stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED] - 60) / 60 + 1.8
		else:
			speed_scale = (entity.stamina_stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED] - 60) / 60 + 1.8
	
	# TODO ! Try to make this system faster, reduce CPU overhead
	#pose[Vector2(0, -15), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0] (check entity's soul)
	for limb in entity.body_pose:
		entity.body_pose[limb][3] = current_state
		entity.body_pose[limb][4] = "parameters/Movement/" + current_state + "/blend_position"
		entity.body_pose[limb][5] = last_direction
		entity.body_pose[limb][7] = speed_scale
	
	for accessory in entity.body_accessories:
		entity.body_accessories[accessory][3] = current_state
		entity.body_accessories[accessory][4] = "parameters/Movement/" + current_state + "/blend_position"
		entity.body_accessories[accessory][5] = last_direction
		entity.body_accessories[accessory][7] = speed_scale
	
	move_body(entity)


## Moves the [param entity]'s body.
## [br][br]
## A body is made up of limbs ([Limb]) and their corresponding accessories ([AccessoriesComponent]).
## This method iterates over each limb to execute [method move_limb] and [method move_accessories].
func move_body(entity: Human):
	for limb in entity.body.limbs:
		move_limb(entity, limb)
		move_accessories(entity, limb)


## Moves an [param entity]'s limb.
## [br][br]
## This method first checks whether the limb exists or not in the entity's body first,
## then calls [method move].
func move_limb(entity: Human, limb_name: String):
	if limb_name in entity.body.limbs and limb_name in entity.body_pose:
		move(entity.body.limbs[limb_name], entity.body_pose[limb_name])


## Moves the [param entity]'s limb accessories.
## [br][br]
## Iterates over the specified limb's accessories and executes [method move]
## on each accessory using its corresponding data from [member Human.body_accessories].
func move_accessories(entity: Human, limb_name: String):
	for accessory in entity.body.limbs[limb_name].accessories.get_children():
		move(accessory, entity.body_accessories[accessory.name])


## Moves a [Limb].
## [br][br]
## For now, it is designed to deal with [member Human.body_pose] and [member Human.body_accessories].
func move(part: Limb, pose: Array):
	part.position = pose[0]                        # Marker2D.position = Vector2()
	part.rotation_degrees = pose[1]                # Marker2D.rotation = degrees
	if part is Limb:
		part.get_child(1)[pose[2]].travel(pose[3]) # animatorTree["parameters/Movement/playback"].travel("")
		part.get_child(1)[pose[4]] = pose[5]       # animatorTree["parameters/Movement/''/blend_position"] = Vector2()
		part.get_child(1)[pose[6]] = pose[7]       # animatorTree["parameters/TimeScale/scale"] = speed_scale


## Stops the [param entity]'s movement.
func stop(entity: Human, stop_velocity: bool):
	if stop_velocity: entity.velocity = Vector2(0,0)
	#pose[Vector2(0, -15), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
	for limb in entity.body_pose:
		entity.body_pose[limb][3] = "Idle"
		entity.body_pose[limb][4] = "parameters/Movement/Idle/blend_position"
		entity.body_pose[limb][5] = last_direction
		entity.body_pose[limb][7] = entity.body.gear["MeleeWeapon"].attack_stats[GameEnums.ATTACK_STATS.WEAPON_SPEED]
		move_limb(entity, limb)


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
