class_name CaveBat extends CharacterBody2D

# DEFAULTS - AVERAGES OF WHAT IS REALISTIC FOR THIS ENTITY'S SIMULATION
# ALL THESE LOC COULD BE IN A MONSTER MANAGER FILE ALONE, EXTENDS COMPONENTS
# FABRICATOR DESIGN PATTERN ?
const DEFAULT_MAX_SPEED = 250
const DEFAULT_STEER_FORCE = 0.1
const DEFAULT_LOOK_AHEAD = 50
const DEFAULT_NUM_RAYS = 8   # TODO - Maybe this should never change at all for most entities (1)
const DEFAULT_BACKOFF_SPEED = 0.2

# PARAMETERS
var ray_directions = []
var added_interest = 5.0
var interest = []
var danger = []

var hostile = false
var backoff_speed = 0.2
var rotating = false

var chosen_dir = Vector2.ZERO
var dir_velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var stunned = false

var path_direction
var opposite_direction

var max_speed = 250
var steer_force = 0.1   # TODO - 0.05 if calm, 0.2 > x > 0.08 if in combat
var look_ahead = 50
var num_rays = 8   # TODO - Maybe this should never change at all for most entities (2)

@onready var cave_bat_animator_tree = $CaveBatAnimationTree
@onready var cave_bat_animator = $CaveBatAnimator
@onready var effects_animator = $EffectsAnimator
@onready var sprite = $CaveBatSprite
@onready var timer = $Timer


func _ready():
	add_to_group("Enemies")
	sprite.play("fly_right")
	timer.start()
	
	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
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
		for i in num_rays:
			var d = ray_directions[i].rotated(rotation).dot(path_direction)
			interest[i] = max(0, d)
	#else:
		#set_default_interest()


#func set_default_interest():
	#for i in num_rays:
		#var d = ray_directions[i].rotated(rotation).dot(transform.x)
		#interest[i] = max(1, d)


func set_danger():
	var space_state = get_world_2d().direct_space_state
	for i in num_rays:
		var query = PhysicsRayQueryParameters2D.create(position, 
			position + ray_directions[i].rotated(rotation) * look_ahead, 12353)
		var result = space_state.intersect_ray(query)
		danger[i] = 1.0 if result else 0.0


#func choose_direction():
	#for i in num_rays:
		#if danger[i] > 0.0:
			#interest[i] = 0.0
	#
	#chosen_dir = Vector2.ZERO
	#for i in num_rays:
		#chosen_dir += ray_directions[i] * interest[i]
	#chosen_dir = chosen_dir.normalized()


# Allows adding to the opposite direction instead of clamping to 0
func choose_direction():
	for i in num_rays:
		if danger[i] > 0.0:
			if i > num_rays/2:
				interest[i - (num_rays/2) - 1] = added_interest
			else:
				interest[i + (num_rays/2) - 1] = added_interest
			interest[i] = 0.0
	
	chosen_dir = Vector2.ZERO
	for i in num_rays:
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
		cave_bat_animator_tree["parameters/Movement/Fly/blend_position"] = chosen_dir
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
	effects_animator.play("effects/hit_flash")
	if randi_range(1, 10) == 1:   # TODO - Create a Dice File with different dice rollers. Crit Dmg
		cave_bat_animator.play("cave_bat/hurt_critical")
	else:
		cave_bat_animator.play("cave_bat/hurt")
	
	if owner and owner.has_method("get_player_path_direction"):
		# path_direction = owner.get_player_path_direction(position)
		opposite_direction = -origin
		print(position, origin, opposite_direction)
	await get_tree().create_timer(1).timeout
	max_speed = DEFAULT_MAX_SPEED
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
	timer.start(1)
