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

var head_sprite

var sword
var body_animator
var isAttacking = false
var left_swing = true


func _ready():
	setup_vars()
	setup_initial_anims()


func setup_vars():
	body_animatorTree = $BodyOrigin/Body/BodySprite/BodyAnimatorTree
	head_animatorTree = $HeadOrigin/Head/HeadSprite/HeadAnimatorTree
	hat_animatorTree = $HeadOrigin/Head/HeadSprite/Hat/HatObject/HatSprite/HatAnimatorTree
	
	body_animator = $BodyOrigin/Body/BodySprite/BodyAnimator
	head_sprite = $HeadOrigin/Head/HeadSprite
	sword = $SwordOrigin


func setup_initial_anims():
	body_state_machine = body_animatorTree["parameters/Movement/playback"]
	head_state_machine = head_animatorTree["parameters/Movement/playback"]
	hat_state_machine  = hat_animatorTree["parameters/Movement/playback"]
	
	head_sprite.play("down")
	
	body_state_machine.travel("Idle")
	head_state_machine.travel("Idle")
	hat_state_machine.travel("Idle")
	body_animatorTree["parameters/Movement/Idle/blend_position"] = Vector2(0, 1)
	head_animatorTree["parameters/Movement/Idle/blend_position"] = Vector2(0, 1)
	hat_animatorTree["parameters/Movement/Idle/blend_position"] = Vector2(0, 1)
	sword.rotation_degrees = -90


func _physics_process(_delta):
	if !isAttacking:
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
		anim_state = "Run"
	else:
		is_sprinting = false
		anim_state = "Move"


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
	else:
		rotate_sword(direction)
		
		if anim_state == "Run":
			body_state_machine.travel("Move")
			body_animatorTree["parameters/Movement/Idle/blend_position"] = direction
			body_animatorTree["parameters/Movement/Move/blend_position"] = direction
		else:
			body_state_machine.travel(anim_state)
			body_animatorTree["parameters/Movement/Idle/blend_position"] = direction
			body_animatorTree["parameters/Movement/" + anim_state + "/blend_position"] = direction
		
		head_state_machine.travel(anim_state)
		head_animatorTree["parameters/Movement/Idle/blend_position"] = direction
		head_animatorTree["parameters/Movement/" + anim_state + "/blend_position"] = direction
		
		hat_animatorTree["parameters/Movement/Idle/blend_position"] = direction


func rotate_sword(direction):
	if direction.y > 0:
		sword.rotation_degrees = -90
		sword.position = Vector2(0, 10)
	elif direction.y < 0:
		sword.rotation_degrees = 90
		sword.position = Vector2(0, -10)
	
	if direction.x > 0:
		sword.rotation_degrees = 180
		sword.position = Vector2(10, 0)
	elif direction.x < 0:
		sword.rotation_degrees = 0
		sword.position = Vector2(-10, 0)


func _on_left_foot_area_entered(area):
	if area.get_parent().is_in_group("Plants"):
		area.get_parent().tilt(-0.1, 0.2, "shake")


func _on_left_foot_area_exited(area):
	if area.get_parent().is_in_group("Plants"):
		area.get_parent().tilt_back()


func _on_right_foot_area_entered(area):
	if area.get_parent().is_in_group("Plants"):
		area.get_parent().tilt(0.1, 0.2, "shake")


func _on_right_foot_area_exited(area):
	if area.get_parent().is_in_group("Plants"):
		area.get_parent().tilt_back()


func _on_sword_attacked():
	isAttacking = true
	var direction = sword.position
	if direction.x < 0:
		body_animator.play("2D Human Body Movement/attack_left")
	elif direction.x > 0:
		body_animator.play("2D Human Body Movement/attack_right")
	elif direction.y < 0:
		body_animator.play("2D Human Body Movement/attack_up")
	elif direction.y >= 0:
		body_animator.play("2D Human Body Movement/attack_down")
	await get_tree().create_timer(body_animator.current_animation_length).timeout
	# body_state_machine.travel("Idle")  # TODO - Fix the last frame, this didn't
	isAttacking = false




	# var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	# if overlapping_mobs.size() > 0:
		# health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		# %ProgressBar.value = health
		# if health <= 0.0:
			# health_depleted.emit()

	



