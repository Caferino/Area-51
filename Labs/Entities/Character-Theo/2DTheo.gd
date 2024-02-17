class_name Theo extends CharacterBody2D

signal health_depleted
#signal plant_collision

const DAMAGE_RATE = 5.0
var health = 100.0
const MAX_SPEED = 3
const MAX_SPRINT_SPEED = 15
const SPRINT_ACCEL = 18
const ACCEL = 2
const DEACCEL = 6

var input_movement_vector = Vector2()
var is_sprinting = false
var dir = Vector2()

var body_animatorTree
var body_state_machine
var head_animatorTree
var head_state_machine
var hat_animatorTree
var hat_state_machine
var anim_state = "Move"


func _ready():
	setup_vars()
	setup_initial_anims()


func setup_vars():
	body_animatorTree = %BodyAnimatorTree
	head_animatorTree = %HeadAnimatorTree
	hat_animatorTree = %HatAnimatorTree


func setup_initial_anims():
	body_state_machine = body_animatorTree["parameters/Movement/playback"]
	head_state_machine = head_animatorTree["parameters/Movement/playback"]
	hat_state_machine  = hat_animatorTree["parameters/Movement/playback"]
	
	body_state_machine.travel("Idle")
	head_state_machine.travel("Idle")
	hat_state_machine.travel("Idle")
	body_animatorTree["parameters/Movement/Idle/blend_position"] = Vector2(0, 1)
	head_animatorTree["parameters/Movement/Idle/blend_position"] = Vector2(0, 1)
	hat_animatorTree["parameters/Movement/Idle/blend_position"] = Vector2(0, 1)


func _physics_process(_delta):
	handle_input()
	handle_movement()
	handle_animation()


func handle_input():
	dir = Vector2()

	if Input.is_action_pressed("move_forward"): dir.y -= 1
	if Input.is_action_pressed("move_back"):    dir.y += 1
	if Input.is_action_pressed("move_right"):   dir.x += 1
	if Input.is_action_pressed("move_left"):    dir.x -= 1
	
	dir = dir.normalized()
	
	if Input.is_action_pressed("sprint"):
		is_sprinting = true
	else:
		is_sprinting = false


func handle_movement():
	var target = dir
	if is_sprinting:
		target *= MAX_SPRINT_SPEED
	else:
		target *= MAX_SPEED
	
	var accel
	var hvel = Vector2()
	if dir.dot(hvel) > 0:
		if is_sprinting:
			accel = SPRINT_ACCEL
		else:
			accel = ACCEL
	else:
		accel = DEACCEL
	
	hvel = hvel.lerp(target, accel)
	velocity = hvel
	move_and_slide()


func handle_animation():
	var direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	#anim_speed = clamp(anim_speed, 0.5, 1.0)
	if direction == Vector2.ZERO:
		body_state_machine.travel("Idle")
		head_state_machine.travel("Idle")
		hat_state_machine.travel("Idle")
	else:
		body_state_machine.travel(anim_state)
		body_animatorTree["parameters/Movement/Idle/blend_position"] = direction
		body_animatorTree["parameters/Movement/" + anim_state + "/blend_position"] = direction
		
		head_state_machine.travel(anim_state)
		head_animatorTree["parameters/Movement/Idle/blend_position"] = direction
		head_animatorTree["parameters/Movement/" + anim_state + "/blend_position"] = direction
		
		hat_state_machine.travel(anim_state)
		hat_animatorTree["parameters/Movement/Idle/blend_position"] = direction
		hat_animatorTree["parameters/Movement/" + anim_state + "/blend_position"] = direction


	
	
	
	
	
	
	
	# ! Do not delete yet
	#if Input.is_action_pressed("ATTACK"): 
		#sword.play(sword_state)
	#else:
		#sword.play("RESET")
		#match direction:
			#Vector2(0, 1): set_animation("walk", "down")
			#Vector2(0, -1): set_animation("walk", "up")
			#Vector2(-1, 0): set_animation("walk", "left")
			#Vector2(1, 0): set_animation("walk", "right")
			#_:
				#if Input.is_action_just_released("MOVE_DOWN"): set_animation("idle", "down")
				#elif Input.is_action_just_released("MOVE_UP"): set_animation("idle", "up")
				#elif Input.is_action_just_released("MOVE_LEFT"): set_animation("idle", "left")
				#elif Input.is_action_just_released("MOVE_RIGHT"): set_animation("idle", "right")
	#
	#if Input.is_action_pressed("ATTACK"): sword.play(sword_state)
	#else: sword.play("RESET")



	
	# var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	# if overlapping_mobs.size() > 0:
		# health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		# %ProgressBar.value = health
		# if health <= 0.0:
			# health_depleted.emit()


#func _on_feet_area_entered(area):
	#if area.get_parent().is_in_group("Plants"):
		#if area.global_position.x > get_global_position().x:
			#area.get_parent().tilt(0.1)
		#else:
			#area.get_parent().tilt(-0.1)
		## area.get_parent().shake()


#func _on_feet_area_exited(area):
	#if area.get_parent().is_in_group("Plants"):
		#area.get_parent().tilt_back()


func _on_left_foot_area_entered(area):
	if area.get_parent().is_in_group("Plants"):
		area.get_parent().tilt(-0.1)


func _on_left_foot_area_exited(area):
	if area.get_parent().is_in_group("Plants"):
		area.get_parent().tilt_back()


func _on_right_foot_area_entered(area):
	if area.get_parent().is_in_group("Plants"):
		area.get_parent().tilt(0.1)


func _on_right_foot_area_exited(area):
	if area.get_parent().is_in_group("Plants"):
		area.get_parent().tilt_back()
