class_name HumanoidMovementComponent extends Node


var last_direction = Vector2(0, 1)

var stats = {
	GameEnums.STAMINA_STATS.CAPACITY         : 100,  # %
	GameEnums.STAMINA_STATS.SPRINT_RATE      :   2,  # -units/s
	GameEnums.STAMINA_STATS.REGEN_RATE       :   3,  # +units/s  # TODO - Small pause b4 recharging
	GameEnums.STAMINA_STATS.MAX_WALK_SPEED   :  10,
	GameEnums.STAMINA_STATS.WALK_ACCEL       :   2,
	GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED :  20,
	GameEnums.STAMINA_STATS.SPRINT_ACCEL     :  15,
	GameEnums.STAMINA_STATS.DEACCEL          :   6,
}


func initiate(n : Dictionary):
	stats[GameEnums.STAMINA_STATS.CAPACITY]         = n[GameEnums.STAMINA_STATS.CAPACITY]
	stats[GameEnums.STAMINA_STATS.SPRINT_RATE]      = n[GameEnums.STAMINA_STATS.SPRINT_RATE]
	stats[GameEnums.STAMINA_STATS.REGEN_RATE]       = n[GameEnums.STAMINA_STATS.REGEN_RATE]
	stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED]   = n[GameEnums.STAMINA_STATS.MAX_WALK_SPEED]
	stats[GameEnums.STAMINA_STATS.WALK_ACCEL]       = n[GameEnums.STAMINA_STATS.WALK_ACCEL]
	stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED] = n[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED]
	stats[GameEnums.STAMINA_STATS.SPRINT_ACCEL]     = n[GameEnums.STAMINA_STATS.SPRINT_ACCEL]
	stats[GameEnums.STAMINA_STATS.DEACCEL]          = n[GameEnums.STAMINA_STATS.DEACCEL]

func get_capacity():                  return stats[GameEnums.STAMINA_STATS.CAPACITY]
func set_capacity(amount):            stats[GameEnums.STAMINA_STATS.CAPACITY] = amount

func get_sprint_rate():               return stats[GameEnums.STAMINA_STATS.SPRINT_RATE]
func set_sprint_rate(amount):         stats[GameEnums.STAMINA_STATS.SPRINT_RATE] = amount

func get_regen_rate():                return stats[GameEnums.STAMINA_STATS.REGEN_RATE]
func set_regen_rate(amount):          stats[GameEnums.STAMINA_STATS.REGEN_RATE] = amount

func get_max_walk_speed():            return stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED]
func set_max_walk_speed(amount):      stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED] = amount

func get_walk_accel():                return stats[GameEnums.STAMINA_STATS.WALK_ACCEL]
func set_walk_accel(amount):          stats[GameEnums.STAMINA_STATS.WALK_ACCEL] = amount

func get_max_sprint_speed():          return stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED]
func set_max_sprint_speed(amount):    stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED] = amount

func get_sprint_acceleration():       return stats[GameEnums.STAMINA_STATS.SPRINT_ACCEL]
func set_sprint_acceleration(amount): stats[GameEnums.STAMINA_STATS.SPRINT_ACCEL] = amount

func get_deacceleration():            return stats[GameEnums.STAMINA_STATS.DEACCEL]
func set_deacceleration(amount):      stats[GameEnums.STAMINA_STATS.DEACCEL] = amount


func handle_movement(entity):
	## TODO - Remaster this
	var target = entity.controller.dir
	#print("dir: ", entity.controller.dir)
	if entity.controller.is_sprinting:
		target *= stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED]
	else:
		target *= stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED]
	#print("target: ", target)
	
	var accel
	var hvel = Vector2()
	#print("DOT RESULT = ", entity.controller.dir.dot(hvel))
	if entity.controller.dir.dot(hvel) > 0:
		if entity.controller.is_sprinting:
			accel = stats[GameEnums.STAMINA_STATS.SPRINT_ACCEL]
			#print("is sprinting accel: ", accel)
		else:
			accel = stats[GameEnums.STAMINA_STATS.WALK_ACCEL]
			#print("not sprinting accel: ", accel)
	else:
		accel = stats[GameEnums.STAMINA_STATS.DEACCEL]
		#print("under 0 accel: ", accel)
	
	hvel = hvel.lerp(target, accel)
	#print("hvel: ", hvel)
	entity.velocity = hvel
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
			speed_scale = stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED] * 0.1 + 0.25
		else:
			speed_scale = stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED] * 0.1 + 1
	
	# TODO ! This can probably be faster, maybe not
	for limb in entity.body_pose:
		#pose[Vector2(0, -15), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0] (check entity's soul)
		entity.body_pose[limb][3] = current_state
		entity.body_pose[limb][4] = "parameters/Movement/" + current_state + "/blend_position"
		entity.body_pose[limb][5] = last_direction
		entity.body_pose[limb][7] = speed_scale
	
	for accessory in entity.body_accessories:
		if accessory == "Weapon": rotate(entity, accessory, direction)
		entity.body_accessories[accessory][3] = current_state
		entity.body_accessories[accessory][4] = "parameters/Movement/" + current_state + "/blend_position"
		entity.body_accessories[accessory][5] = last_direction
		entity.body_accessories[accessory][7] = speed_scale
	
	entity.move_body()


func move_limb(entity, limb):
	if limb in entity.body.limbs and limb in entity.body_pose:
		move(entity.body.limbs[limb], entity.body_pose[limb])


func move_accessories(entity, limb):
	for accessory in entity.body.limbs[limb].accessories.get_children():
		move(accessory, entity.body_accessories[accessory.name])


func move(part, pose):
	part.position = pose[0]                    # Marker2D.position = Vector2()
	part.rotation = pose[1]                    # Marker2D.rotation = degrees
	if part is Limb:
		part.get_child(1)[pose[2]].travel(pose[3]) # animatorTree["parameters/Movement/playback"].travel("")
		part.get_child(1)[pose[4]] = pose[5]       # animatorTree["parameters/Movement/''/blend_position"] = Vector2()
		part.get_child(1)[pose[6]] = pose[7]       # animatorTree["parameters/TimeScale/scale"] = speed_scale


func rotate(entity, accessory, direction):
	entity.weapon.on_left_hand = true
	if direction.y > 0:
		entity.body_accessories[accessory][0] = Vector2(0, 10)
		entity.body_accessories[accessory][1] = -90
		## TODO interaction_area_origin.rotation_degrees = -90
	elif direction.y < 0:
		entity.body_accessories[accessory][0] = Vector2(0, -10)
		entity.body_accessories[accessory][1] = 90
		## TODO interaction_area_origin.rotation_degrees = 90
	
	if direction.x > 0:
		entity.body_accessories[accessory][0] = Vector2(10, 0)
		entity.body_accessories[accessory][1] = 180
		## TODO interaction_area_origin.rotation_degrees = 180
	elif direction.x < 0:
		entity.body_accessories[accessory][0] = Vector2(-10, 0)
		entity.body_accessories[accessory][1] = 0
		## TODO interaction_area_origin.rotation_degrees = 0
	

## TODO ! DO NOT DELETE THIS YET
#weapon_origin.rotation_degrees = -90
#also had %interaction_area and %weapon_origin stuff in initial_vars...
#hat_state_machine  = hat_animatorTree["parameters/Movement/playback"]
#hat_state_machine.travel("Idle")
#hat_animatorTree["parameters/Movement/Idle/blend_position"] = Vector2(0, 1)
