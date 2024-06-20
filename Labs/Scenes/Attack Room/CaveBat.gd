class_name CaveBat extends Entity
## A [color=magenta]Cave Bat[/color], by [color=green]Bizck.

@export var lore        : LoreComponent                  ## The entity's [color=ivory]lore.
@export var heart       : HealthComponent                ## The entity's [color=red]heart.
@export var muscles     : FlyingMammalMovementComponent  ## The entity's [color=salmon]muscles.
@export var timer       : TimerComponent                 ## The entity's [color=white]timers.
@export var effects     : EffectsAnimatorComponent       ## The entity's [color=cornflower]effects.
@export var controller  : EntityController               ## The entity's [color=gray]controller.
@export var body        : BodyComponent                  ## The entity's [color=blue]body.

var interest           = []
var danger             = []
## Should these go on AIEntityController?
#var current_max_speed  = Bizck.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_MAX_SPEED]
#var look_ahead         = Bizck.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_LOOK_AHEAD]
#var added_interest     = Bizck.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_ADDED_INTEREST]
var total_rays         = Bizck.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS]


## Spawns the entity.
func _ready():
	base_stats[GameEnums.STAT.STRENGTH]     = 5
	base_stats[GameEnums.STAT.DEXTERITY]    = 5
	base_stats[GameEnums.STAT.VITALITY]     = 5
	base_stats[GameEnums.STAT.INTELLIGENCE] = 5
	
	stamina_stats[GameEnums.STAMINA_STATS.CAPACITY]         = 100
	stamina_stats[GameEnums.STAMINA_STATS.SPRINT_RATE]      =   2
	stamina_stats[GameEnums.STAMINA_STATS.REGEN_RATE]       =   3
	stamina_stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED]   =  60
	stamina_stats[GameEnums.STAMINA_STATS.WALK_ACCEL]       =   3
	stamina_stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED] = 120
	stamina_stats[GameEnums.STAMINA_STATS.SPRINT_ACCEL]     =   2
	
	body_pose["Torso"] = [Vector2(0, 0), 0, "parameters/Movement/playback", "Fly", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
	spawn()


func spawn():
	var pose = body_pose["Torso"]
	body.limbs["Torso"].animator_tree[pose[2]].travel(pose[3])
	
	interest.resize(total_rays)
	danger.resize(total_rays)


#func _physics_process(delta):
	#if !stunned:
		#set_interest()
		#set_danger()
		#choose_direction()
	#
	#move(delta)


## TODO ! Might deprecate timercomponent for this dude. All this could be an AI?
## What about my Big Tree, use an AI or FSM?




## ============ OLD ============ #
#var current_max_speed  = Bizck.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_MAX_SPEED]
#var look_ahead         = Bizck.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_LOOK_AHEAD]
#var added_interest     = Bizck.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_ADDED_INTEREST]
#var total_rays         = Bizck.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS]
#
#var hostile            = false
#var rotating           = false
#var chosen_dir         = Vector2.ZERO
#var dir_velocity       = Vector2.ZERO
#var stunned            = false
#var path_direction     
#var opposite_direction 
#var steer_force        = 0.1   # TODO - 0.05 if calm, 0.2 > x > 0.08 if in combat
#
## Structure should be as follow
## CaveBat
## > child(0): CollisionShape2D
## > child(1): Sprite2D
## > child(2): AnimationTree
## > child(3): CaveBatAnimator
## > child(4): EffectsAnimator
## > child(5): ContextMap Node2D
## > child(6): Timer
#
#
#
#func set_interest():
	#if owner and owner.has_method("get_player_path_direction"):
		#var path_direction = owner.get_player_path_direction(position)
		##for i in total_rays:
			##var d = ray_directions[i].rotated(rotation).dot(path_direction)
			##interest[i] = max(0, d)
	##else:
		##set_default_interest()
#
#
##func set_default_interest():
	##for i in total_rays:
		##var d = ray_directions[i].rotated(rotation).dot(transform.x)
		##interest[i] = max(1, d)
#
#
#func set_danger():
	#var space_state = get_world_2d().direct_space_state
	#var exclude_layers = 12289  ## Bitmask to avoid layers
	##for i in total_rays:
		##var query = PhysicsRayQueryParameters2D.create(position, 
			##position + ray_directions[i].rotated(rotation) * look_ahead, exclude_layers)
		##var result = space_state.intersect_ray(query)
		##danger[i] = 1.0 if result else 0.0
#
#
##func choose_direction():
	## TODO - These can be fused, be one loop. See if there are more that could fuse
	##for i in total_rays:
		##if danger[i] > 0.0:
			##interest[i] = 0.0
	##
	##chosen_dir = Vector2.ZERO
	##for i in total_rays:
		##chosen_dir += ray_directions[i] * interest[i]
	##chosen_dir = chosen_dir.normalized()
#
#
## Allows adding to the opposite direction instead of clamping to 0
#func choose_direction():
	# TODO Fuse for loops into one here as well maybe
	#for i in total_rays:
		#if danger[i] > 0.0:
			#if i > total_rays/2:
				#interest[i - (total_rays/2) - 1] = added_interest
			#else:
				#interest[i + (total_rays/2) - 1] = added_interest
			#interest[i] = 0.0
	#
	#chosen_dir = Vector2.ZERO
	##for i in total_rays:
		##chosen_dir += ray_directions[i] * interest[i]
	#chosen_dir = chosen_dir.normalized()
#
#
#func move(delta):
	#var desired_velocity = chosen_dir.rotated(rotation) * current_max_speed
	#dir_velocity = dir_velocity.lerp(desired_velocity, steer_force)
	#rotation = dir_velocity.angle() * delta
	#handle_animation()
	## TODO Should be slide maybe
	#move_and_collide(dir_velocity * delta)
#
#
#func handle_animation():
	#if !rotating:
		#rotating = true
		#get_child(2)["parameters/Movement/Fly/blend_position"] = chosen_dir
		#await get_tree().create_timer(0.2).timeout
		#rotating = false
#
#
##func pushback(force_origin_position, knockback_power):
	##var direction = global_position - force_origin_position
	##direction = sign(direction)
#
#
##func back_off(delta):
	##var desired_velocity = chosen_dir.rotated(rotation) * current_max_speed
	##dir_velocity = dir_velocity.lerp(desired_velocity, steer_force)
	##rotation = dir_velocity.angle() * delta
	##move_and_collide(dir_velocity * delta)
#
#
#func hurt(origin):
	#stunned = true
	#current_max_speed = 150  # TODO - Make a parameter and separate in another file or resource maybe
	#get_child(4).play("effects/hit_flash")
	#if randi_range(1, 10) == 1:   # TODO - Create a Dice File with different dice rollers. Crit Dmg
		#get_child(3).play("cave_bat/hurt_critical")
	#else:
		#get_child(3).play("cave_bat/hurt")
	#
	#if owner and owner.has_method("get_player_path_direction"):
		## path_direction = owner.get_player_path_direction(position)
		#opposite_direction = -origin
	#await get_tree().create_timer(1).timeout
	#current_max_speed = Bizck.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_MAX_SPEED]
	#stunned = false
#
#
#func _on_timer_timeout():
	#var rng = randi_range(1, 10)
	#if rng < 3:
		#hostile = true
		#current_max_speed = 350
		#look_ahead = 15
		#print(name, " is Attacking!")
		#await get_tree().create_timer(0.5).timeout
		#look_ahead = 60
		#current_max_speed = 250
		#hostile = false
	#get_child(6).start(1)
