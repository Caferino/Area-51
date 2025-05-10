class_name EntityMovement extends Node
## The entity's [color=salmon]muscles.

## TASK - Check if every entity inheriting this script has a copy of all this
## on each that adds overhead, in case I could move all this into a God and
## have it load just once and for all entities to call it. Centralized method.

signal stopped_moving()  ## Emits whenever the entity stops moving.

var last_direction : Vector2 = Vector2(0, 1)  ## Entity's last faced direction.


## Handles the [param entity]'s movement.
## [br][br]
## Checks the direction of the Player/AI's input first, then uses the entity's 
## stamina_stats to calculate the [member CharacterBody2D.velocity] and the 
## [member AnimationPlayer.speed_scale].
## [br][br]
## This is where [method CharacterBody2D.move_and_slide] resides.
## The direction must be normalized.
func handle_movement(entity: Entity, direction: Vector2, is_sprinting: bool):
	var accel = 0.12  ## Lower for "walking on ice" effect, it'd need DEACCEL, done below
	if direction != Vector2.ZERO:
		if is_sprinting:
			direction *= entity.stamina_stats[GameEnums.STAMINA_STAT.MAX_SPRINT_SPEED]
		else:
			direction *= entity.stamina_stats[GameEnums.STAMINA_STAT.MAX_WALK_SPEED]
	else:
		accel = 0.33  ## Reduce for DEACCEL effect
	
	# TODO - Not sure if I need DeltaTime here, maybe only if it was online?
	## WARNING - Remember: using lerp makes the NPC walk super, super slow for
	## a tiny fraction of a second at the very end. Forcing the use of direct anim_state
	entity.velocity = entity.velocity.lerp(direction, accel)
	entity.move_and_slide()
	## TODO - Alternative to add custom logic when colliding with rigidbodies
	#if entity.move_and_slide():
		#print("True slide")
		#for i in entity.get_slide_collision_count():
			#print("Inside collision")
			#var c = entity.get_slide_collision(i)
			#if c.get_collider() is HangingDecor:
				#print("HangingDecor collided")
	
	# This block prevents the entire animation process from running every physics frame unnecessarily
	if entity.velocity.is_zero_approx() and entity.velocity != Vector2.ZERO:
		entity.velocity = Vector2.ZERO
		stopped_moving.emit()
		handle_animation(entity, direction, is_sprinting)
	elif entity.velocity != Vector2.ZERO: 
		handle_animation(entity, direction, is_sprinting)


## Handles the [param entity]'s animation.
## [br][br]
## Checks whether the entity has gone idle or is walking/running. It uses the
## following formula to calculate the [member AnimationPlayer.speed_scale]:
## [codeblock]
## if current_state == "Run":
##     speed_scale = (entity.stamina_stats[GameEnums.STAMINA_STAT.MAX_SPRINT_SPEED] - 60) / 60 + 1.8
## else:
##     speed_scale = (entity.stamina_stats[GameEnums.STAMINA_STAT.MAX_WALK_SPEED] - 60) / 60 + 1.8
## [/codeblock]
## The default speed_scale value of 1.0 felt too slow for the entity's movement.
## A value between 1.8 - 2.0 provides a more snappy and arcade feel.
## The subtraction and division by 60 adjust the entity's speed to an appropriate
## range for the [member AnimationPlayer.speed_scale].
## Example: If the character's move speed is 60px/s, its speed_scale is equal to 1.8.
## [br]
## It updates the [member Human.body_pose] of the entity and then calls
## [method move_body] to execute the assigned values on the actual animation nodes.
func handle_animation(entity: Entity, direction: Vector2, is_sprinting: bool):
	var current_state = entity.controller.anim_state
	var speed_scale   = 1.0
	if direction != Vector2.ZERO:
		last_direction = direction
		if is_sprinting:
			speed_scale = (entity.stamina_stats[GameEnums.STAMINA_STAT.MAX_SPRINT_SPEED] - 60) / 60 + 1.8
		else:
			speed_scale = (entity.stamina_stats[GameEnums.STAMINA_STAT.MAX_WALK_SPEED] - 60) / 60 + 1.8
	
	# TODO ! Try to make this system faster, reduce CPU overhead
	#pose[Vector2(0, -15), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", 
	#Vector2(0, 1), "parameters/TimeScale/scale", 1.0] (check entity's soul)
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
func move_body(entity: Entity):
	for limb in entity.body.limbs:
		move_limb(entity, limb)
		move_accessories(entity, limb)


## Moves an [param entity]'s limb.
## [br][br]
## This method first checks whether the limb exists or not in the entity's body first,
## then calls [method move].
func move_limb(entity: Entity, limb_name: String):
	if limb_name in entity.body.limbs and limb_name in entity.body_pose:
		move(entity.body.limbs[limb_name], entity.body_pose[limb_name])


## Moves the [param entity]'s limb accessories.
## [br][br]
## Iterates over the specified limb's accessories and executes [method move]
## on each accessory using its corresponding data from [member Human.body_accessories].
func move_accessories(entity: Entity, limb_name: String):
	for accessory in entity.body.limbs[limb_name].accessories.get_children():
		move(accessory, entity.body_accessories[accessory.name])


## Moves a [Limb] or [Accessory].
## [br][br]
## For now, it is designed to deal with [member Human.body_pose] and [member Human.body_accessories].
func move(part: Limb, pose: Array):
	part.position = pose[0]                        # Marker2D.position = Vector2()
	part.rotation_degrees = pose[1]                # Marker2D.rotation = degrees
	if part is Limb:
		part.animator_tree[pose[2]].travel(pose[3]) # animatorTree["parameters/Movement/playback"].travel("")
		part.animator_tree[pose[4]] = pose[5]       # animatorTree["parameters/Movement/''/blend_position"] = Vector2()
		part.animator_tree[pose[6]] = pose[7]       # animatorTree["parameters/TimeScale/scale"] = speed_scale


## Stops the [param entity]'s movement.
func stop(entity: Entity, stop_velocity: bool):
	if stop_velocity: entity.velocity = Vector2(0,0)
	for limb in entity.body_pose:
		entity.body_pose[limb][3] = "Idle"
		entity.body_pose[limb][4] = "parameters/Movement/Idle/blend_position"
		entity.body_pose[limb][5] = last_direction
		entity.body_pose[limb][7] = entity.body.gear["MeleeWeapon"].tool_stats[GameEnums.TOOL_STAT.SPEED]
		move_limb(entity, limb)
