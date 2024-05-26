class_name Theo extends CharacterBody2D

@export var player_data : PlayerData

var interfaces = [
	#GameEnums.INTERFACE.DAMAGEABLE,
	#GameEnums.INTERFACE.FLAMMABLE
]

signal health_depleted
#signal plant_collision

const DAMAGE_RATE = 5.0
var health = 100.0
const MAX_SPEED = 10
const MAX_SPRINT_SPEED = 20
const SPRINT_ACCEL = 15
const ACCEL = 2
const DEACCEL = 6

var input_movement_vector = Vector2()
var is_sprinting = false
var dir = Vector2()

var body_animator
var body_animatorTree
var body_state_machine
var head_animatorTree
var head_state_machine
var hat_animatorTree
var hat_state_machine
var anim_state = "Move"
var head_sprite
var weapon_origin

var interaction_area_origin
var interaction_area
var isAttacking = false
var on_left_hand = true   # left handed weapon carry


func _ready():
	InterfaceManager.validate(self)
	connect_signals()
	setup_vars()
	setup_initial_anims()


func connect_signals():
	SignalManager.item_dropped.connect(_on_item_dropped)
	player_data.changed.connect(_on_data_changed)
	_on_data_changed()


func setup_vars():
	body_animatorTree = $BodyOrigin/Body/BodySprite/BodyAnimatorTree
	head_animatorTree = $HeadOrigin/Head/HeadSprite/HeadAnimatorTree
	hat_animatorTree = $HeadOrigin/Head/HeadSprite/Hat/HatObject/HatSprite/HatAnimatorTree
	
	body_animator = $BodyOrigin/Body/BodySprite/BodyAnimator
	head_sprite = $HeadOrigin/Head/HeadSprite
	weapon_origin = $WeaponOrigin
	interaction_area_origin = $InteractionAreaOrigin
	interaction_area = $InteractionAreaOrigin/InteractionArea


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
	
	weapon_origin.rotation_degrees = -90


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
	
	if Input.is_action_just_pressed("interact"):
		if interaction_area.get_overlapping_bodies():
			interact()
		if interaction_area.get_overlapping_areas():
			pass


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
		rotate_weapon(direction)
		
		if anim_state == "Run":
			body_state_machine.travel("Move")
			body_animatorTree["parameters/TimeScale/scale"] = MAX_SPRINT_SPEED * 0.05 + 0.5
			body_animatorTree["parameters/Movement/Idle/blend_position"] = direction
			body_animatorTree["parameters/Movement/Move/blend_position"] = direction
		else:
			body_state_machine.travel(anim_state)
			body_animatorTree["parameters/TimeScale/scale"] = MAX_SPEED * 0.05 + 0.5
			body_animatorTree["parameters/Movement/Idle/blend_position"] = direction
			body_animatorTree["parameters/Movement/" + anim_state + "/blend_position"] = direction
		
		head_state_machine.travel(anim_state)
		head_animatorTree["parameters/Movement/Idle/blend_position"] = direction
		head_animatorTree["parameters/Movement/" + anim_state + "/blend_position"] = direction
		
		hat_animatorTree["parameters/Movement/Idle/blend_position"] = direction


func rotate_weapon(direction):
	on_left_hand = true
	if direction.y > 0:
		weapon_origin.rotation_degrees = -90
		weapon_origin.position = Vector2(0, 10)
		interaction_area_origin.rotation_degrees = -90
	elif direction.y < 0:
		weapon_origin.rotation_degrees = 90
		weapon_origin.position = Vector2(0, -10)
		interaction_area_origin.rotation_degrees = 90
	
	if direction.x > 0:
		weapon_origin.rotation_degrees = 180
		weapon_origin.position = Vector2(10, 0)
		interaction_area_origin.rotation_degrees = 180
	elif direction.x < 0:
		weapon_origin.rotation_degrees = 0
		weapon_origin.position = Vector2(-10, 0)
		interaction_area_origin.rotation_degrees = 0


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


func _on_weapon_attacked(weapon):
	if !isAttacking:
		isAttacking = true
		body_state_machine.travel("Idle")
		head_state_machine.travel("Idle")
		
		weapon.draw()
		var direction = weapon_origin.position
		play_attack_animation(direction, weapon)


func play_attack_animation(direction, weapon):
	body_animator.speed_scale = weapon.weapon_speed
	weapon.update_speed(weapon.weapon_speed)
	if direction.x < 0:  # These depend on how were the AnimationPlayers setup
		if on_left_hand:
			body_animator.play("attack_left")
			weapon.animator.play("attack_right")
		else:
			body_animator.play_backwards("attack_left")
			weapon.animator.play_backwards("attack_right")
	elif direction.x > 0:
		if on_left_hand:
			body_animator.play_backwards("attack_right")
			weapon.animator.play_backwards("attack_left")
		else:
			body_animator.play("attack_right")
			weapon.animator.play("attack_left")
	elif direction.y < 0:
		if on_left_hand:
			body_animator.play("attack_up")
			weapon.animator.play_backwards("attack_left")
		else:
			body_animator.play_backwards("attack_up")
			weapon.animator.play("attack_left")
	elif direction.y >= 0:
		if on_left_hand:
			body_animator.play("attack_down")
			weapon.animator.play_backwards("attack_left")
		else:
			body_animator.play_backwards("attack_down")
			weapon.animator.play("attack_left")
	
	on_left_hand = !on_left_hand


func _on_body_animator_animation_finished(_anim_name):
	weapon_origin.get_node("Weapon").sheathe()
	isAttacking = false


	# var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	# if overlapping_mobs.size() > 0:
		# health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		# %ProgressBar.value = health
		# if health <= 0.0:
			# health_depleted.emit()

#func collect(item):   # DEPRECATED
	#inv.insert(item)


# TODO - Change interaction_area to a raycast, I forgot why I chose a rectangle, there's a why
## Executes the interactable's "interact(item)" function
## "Press 'F' so Theo interacts with..."
func interact():
	var bodies = interaction_area.get_overlapping_bodies()
	bodies[0].get_parent().interact("hatchet")  # TODO - Enums/Dictionary of interactable_with...

# TODO - What if every interactable has a interact_with(item)? Best extension option so far
# Wouldn't break what I have plus it does sound more correct and modular
# A JSON where the interactable has a "interacts_with" = [ENUMS] it can react to
# In GTA V, how do they know what kind of bullet or item turns gasoline on fire f.e.?

func _on_body_area_body_entered(body):
	if body.is_in_group("Enemies"):
		print("Ouch!!!")


func _on_body_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Collectable"):
		area.pick_up()
	elif area.is_in_group("Interactive"):
		pass


func _on_item_dropped( item ):
	var floor_item = AlcarodianResourceManager.tscn.floor_item.instantiate()
	floor_item.item = item
	get_parent().add_child( floor_item )
	floor_item.position = position


func _on_data_changed():
	global_position = player_data.global_position
