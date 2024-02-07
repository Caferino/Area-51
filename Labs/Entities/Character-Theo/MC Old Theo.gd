extends CharacterBody3D

const GRAVITY = -20
var vel = Vector3()
# var anim_speed = 1
var anim_state = "Walk"
const MAX_SPEED = 3
const MAX_SPRINT_SPEED = 30
const SPRINT_ACCEL = 18
const JUMP_SPEED = 6
const ACCEL = 2
const DEACCEL = 6
const ROTATION_SPEED = 100

var dir = Vector3()

const MAX_SLOPE_ANGLE = 40

var camera
var camera_base

var MOUSE_SENSITIVITY = 0.1
var is_sprinting = false

var body_animatorTree
var head_animatorTree

func _ready():
	setup_vars()
	setup_initial_anims()


func _physics_process(delta):
	# ai_movement_controller()
	handle_input()
	handle_movement(delta)
	
	handle_animation()
	
	apply_gravity()
	move_and_slide()


func setup_vars():
	camera = %Camera
	camera_base = %"Camera Base"
	body_animatorTree = %BodyAnimatorTree
	head_animatorTree = %HeadAnimatorTree


func setup_initial_anims():
	body_animatorTree.get("parameters/Movement/playback").travel("Idle")
	head_animatorTree.get("parameters/Movement/playback").travel("Idle")
	body_animatorTree.set("parameters/Movement/Idle/blend_position", Vector2(0, 1))
	head_animatorTree.set("parameters/Movement/Idle/blend_position", Vector2(0, 1))


func handle_input():
	dir = Vector3()
	var cam_xform = camera.get_global_transform()
	var input_movement_vector = Vector2()

	if Input.is_action_pressed("move_right"):
		input_movement_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("move_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("move_back"):
		input_movement_vector.y -= 1
	
	input_movement_vector = input_movement_vector.normalized()
	
	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	
	#input_vector = input_vector.normalized()
	#var rotated_input = camera_rotation_degrees(input_vector)
	#rotated_input = rotated_input.normalized()
	#
	#velocity.x = input_vector.x * speed
	#velocity.z = input_vector.z * speed
	
	if Input.is_action_pressed("sprint"):
		is_sprinting = true
	else:
		is_sprinting = false

	if Input.is_action_just_pressed("jump"):
		jump()

	if Input.is_action_pressed("rotate_camera"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func handle_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	
	vel.y += delta * GRAVITY
	
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	if is_sprinting:
		anim_state = "Run"
		target *= MAX_SPRINT_SPEED
	else:
		anim_state = "Walk"
		target *= MAX_SPEED
	
	var accel
	if dir.dot(hvel) > 0:
		if is_sprinting:
			accel = SPRINT_ACCEL
		else:
			accel = ACCEL
	else:
		accel = DEACCEL
	
	hvel = hvel.lerp(target, accel * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	move_and_slide()


func handle_animation():
	var direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	#anim_speed = clamp(anim_speed, 0.5, 1.0)
	if direction == Vector2.ZERO:
		body_animatorTree.get("parameters/Movement/playback").travel("Idle")
		head_animatorTree.get("parameters/Movement/playback").travel("Idle")
	else:
		head_animatorTree.get("parameters/Movement/playback").travel(anim_state)
		head_animatorTree.set("parameters/Movement/Idle/blend_position", direction)
		head_animatorTree.set("parameters/Movement/" + anim_state + "/blend_position", direction)
		
		body_animatorTree.get("parameters/Movement/playback").travel(anim_state)
		body_animatorTree.set("parameters/Movement/Idle/blend_position", direction)
		body_animatorTree.set("parameters/Movement/" + anim_state + "/blend_position", direction)


func handle_sprint_anim():
	pass
#func camera_rotation_degrees(input_vector):
	#var camera_rotation = deg_to_rad(-rotation_degrees.y)  # Adjust the node path
	#return input_vector.rotated(Vector3(0, camera_rotation, 0).normalized(), 0)


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera_base.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		
		var camera_rot = camera_base.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -20, 20)
		camera_base.rotation_degrees = camera_rot


func jump():
	if is_on_floor():
		velocity.y = JUMP_SPEED


func apply_gravity():
	if not is_on_floor():
		velocity.y += get_physics_process_delta_time() * GRAVITY
