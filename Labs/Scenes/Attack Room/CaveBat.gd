class_name CaveBat extends CharacterBody2D

## Structure should be as follow
## CaveBat
## > child(0): CollisionShape2D
## > child(1): Sprite2D
## > child(2): AnimationTree
## > child(3): CaveBatAnimator
## > child(4): EffectsAnimator
## > child(5): ContextMap Node2D
## > child(6): Timer

# PARAMETERS
var ray_directions = []
var interest = []
var danger = []

var max_speed      = 250 #= AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_MAX_SPEED]
var look_ahead     = 50  #= AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_LOOK_AHEAD]
var added_interest = 5.0 #= AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_ADDED_INTEREST]

var hostile = false
var rotating = false
var chosen_dir = Vector2.ZERO
var dir_velocity = Vector2.ZERO
var stunned = false
var path_direction
var opposite_direction
var steer_force = 0.1   # TODO - 0.05 if calm, 0.2 > x > 0.08 if in combat
#var back_off_speed = 0.2 # TODO - When to use? Same for editing added_interest
#var acceleration = Vector2.ZERO


func _ready():
	add_to_group("Enemies")
	get_child(1).play("fly_right")
	get_child(6).start()
	
	interest.resize(AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS])
	danger.resize(AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS])
	ray_directions.resize(AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS])
	for i in AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS]:
		var angle = i * 2 * PI / AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS]
		ray_directions[i] = Vector2.RIGHT.rotated(angle)


func _physics_process(delta):
	if !stunned:
		set_interest()
		set_danger()
		choose_direction()
	
	move(delta)


func set_interest():
	if owner and owner.has_method("get_player_path_direction"):
		var path_direction = owner.get_player_path_direction(position)
		for i in AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS]:
			var d = ray_directions[i].rotated(rotation).dot(path_direction)
			interest[i] = max(0, d)
	#else:
		#set_default_interest()


#func set_default_interest():
	#for i in AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS]:
		#var d = ray_directions[i].rotated(rotation).dot(transform.x)
		#interest[i] = max(1, d)


func set_danger():
	var space_state = get_world_2d().direct_space_state
	for i in AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS]:
		var query = PhysicsRayQueryParameters2D.create(position, 
			position + ray_directions[i].rotated(rotation) * look_ahead, 12289)
		var result = space_state.intersect_ray(query)
		danger[i] = 1.0 if result else 0.0


#func choose_direction():
	#for i in AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS]:
		#if danger[i] > 0.0:
			#interest[i] = 0.0
	#
	#chosen_dir = Vector2.ZERO
	#for i in AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS]:
		#chosen_dir += ray_directions[i] * interest[i]
	#chosen_dir = chosen_dir.normalized()


# Allows adding to the opposite direction instead of clamping to 0
func choose_direction():
	for i in AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS]:
		if danger[i] > 0.0:
			if i > AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS]/2:
				interest[i - (AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS]/2) - 1] = added_interest
			else:
				interest[i + (AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS]/2) - 1] = added_interest
			interest[i] = 0.0
	
	chosen_dir = Vector2.ZERO
	for i in AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_NUM_RAYS]:
		chosen_dir += ray_directions[i] * interest[i]
	chosen_dir = chosen_dir.normalized()


func move(delta):
	var desired_velocity = chosen_dir.rotated(rotation) * max_speed
	dir_velocity = dir_velocity.lerp(desired_velocity, steer_force)
	rotation = dir_velocity.angle() * delta
	handle_animation()
	move_and_collide(dir_velocity * delta)


func handle_animation():
	if !rotating:
		rotating = true
		get_child(2)["parameters/Movement/Fly/blend_position"] = chosen_dir
		await get_tree().create_timer(0.2).timeout
		rotating = false


#func pushback(force_origin_position, knockback_power):
	#var direction = global_position - force_origin_position
	#direction = sign(direction)


#func back_off(delta):
	#var desired_velocity = chosen_dir.rotated(rotation) * max_speed
	#dir_velocity = dir_velocity.lerp(desired_velocity, steer_force)
	#rotation = dir_velocity.angle() * delta
	#move_and_collide(dir_velocity * delta)


func hurt(origin):
	stunned = true
	max_speed = 150  # TODO - Make a parameter and separate in another file or resource maybe
	get_child(4).play("effects/hit_flash")
	if randi_range(1, 10) == 1:   # TODO - Create a Dice File with different dice rollers. Crit Dmg
		get_child(3).play("cave_bat/hurt_critical")
	else:
		get_child(3).play("cave_bat/hurt")
	
	if owner and owner.has_method("get_player_path_direction"):
		# path_direction = owner.get_player_path_direction(position)
		opposite_direction = -origin
	await get_tree().create_timer(1).timeout
	max_speed = AlcarodianResourceManager.animals["CaveBat"][GameEnums.AI_STATS.DEFAULT_MAX_SPEED]
	stunned = false


func _on_timer_timeout():
	var rng = randi_range(1, 10)
	if rng < 3:
		hostile = true
		max_speed = 350
		look_ahead = 15
		print(name, " is Attacking!")
		await get_tree().create_timer(0.5).timeout
		look_ahead = 60
		max_speed = 250
		hostile = false
	get_child(6).start(1)
