class_name HumanoidMovementComponent extends Node

var last_direction = Vector2(0, 1)
var weapon_on_left_hand = true


func handle_movement(entity):
	## TODO - Remaster this
	var target = entity.controller.dir
	#print("dir: ", entity.controller.dir)
	if entity.controller.is_sprinting:
		target *= entity.stamina_stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED]
	else:
		target *= entity.stamina_stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED]
	#print("target: ", target)
	
	var accel
	var hvel = Vector2()
	#print("DOT RESULT = ", entity.controller.dir.dot(hvel))
	if entity.controller.dir.dot(hvel) > 0:
		if entity.controller.is_sprinting:
			accel = entity.stamina_stats[GameEnums.STAMINA_STATS.SPRINT_ACCEL]
			#print("is sprinting accel: ", accel)
		else:
			accel = entity.stamina_stats[GameEnums.STAMINA_STATS.WALK_ACCEL]
			#print("not sprinting accel: ", accel)
	else:
		accel = entity.stamina_stats[GameEnums.STAMINA_STATS.DEACCEL]
		#print("under 0 accel: ", accel)
	
	hvel = hvel.lerp(target, accel)
	#print("hvel: ", hvel)
	entity.velocity = hvel
	entity.move_and_slide()
	handle_animation(entity)


func handle_animation(entity):
	var current_state = entity.controller.anim_state
	var speed_scale   = 1.0
	var direction     = entity.controller.dir
	if direction == Vector2.ZERO:
		current_state = "Idle"
	else:
		last_direction = direction
		if current_state == "Run":
			speed_scale = entity.stamina_stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED] * 0.1 + 0.25
		else:
			speed_scale = entity.stamina_stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED] * 0.1 + 1
	
	# TODO ! This can probably be faster, maybe not
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


func move_body(entity):
	for limb in entity.body.limbs:
		move_limb(entity, limb)
		move_accessories(entity, limb)


func move_limb(entity, limb):
	if limb in entity.body.limbs and limb in entity.body_pose:
		move(entity.body.limbs[limb], entity.body_pose[limb])


func move_accessories(entity, limb):
	for accessory in entity.body.limbs[limb].accessories.get_children():
		move(accessory, entity.body_accessories[accessory.name])


func move(part, pose):
	part.position = pose[0]                        # Marker2D.position = Vector2()
	part.rotation_degrees = pose[1]                # Marker2D.rotation = degrees
	if part is Limb:
		part.get_child(1)[pose[2]].travel(pose[3]) # animatorTree["parameters/Movement/playback"].travel("")
		part.get_child(1)[pose[4]] = pose[5]       # animatorTree["parameters/Movement/''/blend_position"] = Vector2()
		part.get_child(1)[pose[6]] = pose[7]       # animatorTree["parameters/TimeScale/scale"] = speed_scale


func stop(entity):
	#pose[Vector2(0, -15), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
	for limb in entity.body_pose:
		entity.body_pose[limb][3] = "Idle"
		entity.body_pose[limb][4] = "parameters/Movement/Idle/blend_position"
		entity.body_pose[limb][5] = last_direction
		entity.body_pose[limb][7] = entity.body.gear["MeleeWeapon"].attack_stats[GameEnums.ATTACK_STATS.WEAPON_SPEED]
		move_limb(entity, limb)


func attack(weapon, torso_animator, head_animator):
	if last_direction.y > 0:    # DOWN
		weapon.position = Vector2(0, 5)
		weapon.rotation_degrees = 90
		if weapon_on_left_hand:
			torso_animator.play("attack_down")
			head_animator.play_backwards("attack_down")
			weapon.animator.play("attack_right")
		else:
			torso_animator.play_backwards("attack_down")
			head_animator.play("attack_down")
			weapon.animator.play("attack_left")
	elif last_direction.y < 0:  # UP
		weapon.position = Vector2(0, -10)
		weapon.rotation_degrees = -90
		if weapon_on_left_hand:
			torso_animator.play("attack_up")
			head_animator.play_backwards("attack_up")
			weapon.animator.play("attack_right")
		else:
			torso_animator.play_backwards("attack_up")
			head_animator.play("attack_up")
			weapon.animator.play("attack_left")
	
	if last_direction.x > 0:    # RIGHT
		weapon.position = Vector2(5, 0)
		weapon.rotation_degrees = 0
		if weapon_on_left_hand:
			torso_animator.play_backwards("attack_right")
			head_animator.play_backwards("attack_right")
			weapon.animator.play("attack_right")
		else:
			torso_animator.play("attack_right")
			head_animator.play("attack_right")
			weapon.animator.play("attack_left")
	elif last_direction.x < 0:  # LEFT
		weapon.position = Vector2(-5, 0)
		weapon.rotation_degrees = 180
		if weapon_on_left_hand:
			torso_animator.play("attack_left")
			head_animator.play_backwards("attack_left")
			weapon.animator.play("attack_right")
		else:
			torso_animator.play_backwards("attack_left")
			head_animator.play("attack_left")
			weapon.animator.play("attack_left")
	
	weapon_on_left_hand = !weapon_on_left_hand
