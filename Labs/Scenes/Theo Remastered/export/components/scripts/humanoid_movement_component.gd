class_name HumanoidMovementComponent extends Node

var body_animator   ## TODO - Might DEPRECATED all these, BodyComponent has them
var body_animatorTree
var body_state_machine
var head_animatorTree
var head_state_machine
var hat_animatorTree
var hat_state_machine
var anim_state = "Move"
var head_sprite
var weapon_origin

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



## TODO - What if these two setup_vars and setup_initial_anims go in BodyComponent?
## TODO - Might become DEPRECATED soon, check weapon_origin and interaction are done
func setup_vars():
	pass
	#body_animatorTree = $BodyOrigin/Body/BodySprite/BodyAnimatorTree
	#head_animatorTree = $HeadOrigin/Head/HeadSprite/HeadAnimatorTree
	#hat_animatorTree = $HeadOrigin/Head/HeadSprite/Hat/HatObject/HatSprite/HatAnimatorTree
	#
	#body_animator = $BodyOrigin/Body/BodySprite/BodyAnimator
	#head_sprite = $HeadOrigin/Head/HeadSprite
	#weapon_origin = $WeaponOrigin
	#interaction_area_origin = $InteractionAreaOrigin
	#interaction_area = $InteractionAreaOrigin/InteractionArea


func setup_initial_anims():
	pass
	#weapon_origin.rotation_degrees = -90


func handle_movement():
	## TODO - Remaster this shit, it's so wrong.
	pass
	#var target = dir
	#print("dir: ", dir)
	#if is_sprinting:
		#target *= MAX_SPRINT_SPEED
	#else:
		#target *= MAX_SPEED
	#print("target: ", target)
	#
	#var accel
	#var hvel = Vector2()
	#print("DOT RESULT = ", dir.dot(hvel))
	#if dir.dot(Vector2(1,1)) > 0:
		#if is_sprinting:
			#accel = SPRINT_ACCEL
			#print("is sprinting accel: ", accel)
		#else:
			#accel = ACCEL
			#print("not sprinting accel: ", accel)
	#else:
		#accel = DEACCEL
		#print("under 0 accel: ", accel)
	#
	#hvel = hvel.lerp(target, accel)
	#print("hvel: ", hvel)
	#velocity = hvel
	#move_and_slide()


func handle_animation(body):
	pass
	#var direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	#anim_speed = clamp(anim_speed, 0.5, 1.0)
	#if direction == Vector2.ZERO:
		#body_state_machine.travel("Idle")
		#head_state_machine.travel("Idle")
	#else:
		#rotate_weapon(direction)
		#
		#if anim_state == "Run":
			#body_state_machine.travel("Move")
			#body_animatorTree["parameters/TimeScale/scale"] = MAX_SPRINT_SPEED * 0.05 + 0.5
			#body_animatorTree["parameters/Movement/Idle/blend_position"] = direction
			#body_animatorTree["parameters/Movement/Move/blend_position"] = direction
		#else:
			#body_state_machine.travel(anim_state)
			#body_animatorTree["parameters/TimeScale/scale"] = MAX_SPEED * 0.05 + 0.5
			#body_animatorTree["parameters/Movement/Idle/blend_position"] = direction
			#body_animatorTree["parameters/Movement/" + anim_state + "/blend_position"] = direction
		#
		#head_state_machine.travel(anim_state)
		#head_animatorTree["parameters/Movement/Idle/blend_position"] = direction
		#head_animatorTree["parameters/Movement/" + anim_state + "/blend_position"] = direction
		#
		#hat_animatorTree["parameters/Movement/Idle/blend_position"] = direction


func wake_up(limb):
	limb.play("default")


func move_limb(limb, pose):
	limb.get_child(2)[pose[0]].travel("Move")
	limb.get_child(2)["parameters/Movement/Move/blend_position"] = pose[3]
	
	print(limb.get_child(2)[pose[2]])
	print(pose)
	## TODO ! DO NOT DELETE THIS, USE IT TO DOCUMENT THIS ABOMINATION
	#body_state_machine = body_animatorTree["parameters/Movement/playback"]
	#head_state_machine = head_animatorTree["parameters/Movement/playback"]
	#hat_state_machine  = hat_animatorTree["parameters/Movement/playback"]
	#
	#head_sprite.play("down")
	#
	#body_state_machine.travel("Idle")
	#head_state_machine.travel("Idle")
	#hat_state_machine.travel("Idle")
	#body_animatorTree["parameters/Movement/Idle/blend_position"] = Vector2(0, 1)
	#head_animatorTree["parameters/Movement/Idle/blend_position"] = Vector2(0, 1)
	#hat_animatorTree["parameters/Movement/Idle/blend_position"] = Vector2(0, 1)
