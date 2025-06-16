class_name PlayerControllerComponent extends EntityController
## The entity's [color=gold]player controller.

@export var player              : Entity           ## The player itself.
@export var camera_base         : CameraBase       ## The player's camera base.
@export var area_trigger        : Area2D           ## The entity's feet, trigger areas, walk sounds...
@export var interactor_area     : Area2D           ## The interactor's monitoring area.
@export var interactor_animator : AnimationTree    ## The interactor's animator (for rotation).
@export var walk_vfx            : AnimatedSprite2D ## The entity's walking effects (grass, water...)
# TODO @export var looting_area  : Area2D          ## The player's looting pick-up range.


func _ready() -> void:
	Dialogic.signal_event.connect(dialogic_signal)


## Checks whether the player is giving movement input every physics frame.
func _physics_process(_delta: float) -> void:
	if !attacking and !gathering and !rolling:# and !is_talking:
		check_movement()
		check_tile_type()


## Runs whenever there is an [InputEvent] to check whether it's an attack or interaction.
## TODO - Room for improvement: maybe using _unhandled_input(), a Dict with functions and StringNames...
## WARN TODO - Sometimes double input are read, not sure if it's my faulty keyboard or this
## WARN NOTE - If this ever seems to fail, make sure there are no Control nodes or ColorRects
## somewhere with their Mouse input handle mode in 'Stop'. Change them to 'Pass'.
func _unhandled_input(event: InputEvent) -> void:
	if aiming:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			confirm_action()
	elif !attacking and !gathering and !is_talking and event is not InputEventMouseMotion:
		if !rolling and !swimming:
			if Input.is_action_just_pressed("attack"):
				entity_attack.emit()
			elif Input.is_action_just_pressed("gather"):
				entity_gather.emit()
			elif Input.is_action_just_pressed("action_1"):
				on_action_1()
			elif Input.is_action_just_pressed("action_2"):
				on_action_2()
		if Input.is_action_just_pressed("interact"):
			entity_interact.emit()
		elif Input.is_action_just_pressed("speak_to"):
			if speakers: run_dialogue("test")
		# NOTE - Feels wrong. DRY... Is there a better way, no loops?
		# TODO - For now, it shoots a fireball, but it should use the item in the given keybind/hotbar
		


## Reads the player's given movement input.
## [br][br]
## In 2D, the y-axis is facing down. This means (0,-1) is up, and (0, 1) is down.
func check_movement():
	dir = Vector2()
	
	if Input.is_action_pressed("move_forward") : dir.y -= 1
	if Input.is_action_pressed("move_back")    : dir.y += 1
	if Input.is_action_pressed("move_right")   : dir.x += 1
	if Input.is_action_pressed("move_left")    : dir.x -= 1
	
	if dir != Vector2.ZERO:
		if !moving: 
			moving = true
			entity_move.emit()
		
		dir = dir.normalized()
		
		if Input.is_action_pressed("sprint"):
			if !sprinting: entity_sprint.emit()
			sprinting  = true
			anim_state = "Run"
		else:
			if sprinting: entity_move.emit()
			sprinting  = false
			anim_state = "Move"
	else:
		anim_state = "Idle"
		moving = false
	
	if Input.is_action_just_pressed("roll") and !swimming:
		entity_roll.emit()
		moving = true
		rolling = true
		anim_state = "Roll"


## Checks the tile the entity is currently standing on.
func check_tile_type():
	SignalManager.check_tile_type.emit(Vector2i(area_trigger.get_child(0).global_position), self)


## Rotates the interactor's [member Marker2D.rotation].
func rotate_interactor(direction: Vector2):
	interactor_animator["parameters/Movement/blend_position"] = direction


func on_roll():
	if camera_base.dragging_cam : camera_base.stop_dragging()
	camera_base.modify_breath(-2.0, 2.0, -6.0, 6.0, 0.2)


func on_move():
	if camera_base.dragging_cam : camera_base.stop_dragging()
	camera_base.modify_breath(-2.0, 2.0, -3.0, 3.0, 0.4)


func on_sprint():
	if camera_base.dragging_cam : camera_base.stop_dragging()
	camera_base.modify_breath(-2.0, 2.0, -6.0, 6.0, 0.2)


func on_stop():
	camera_base.reset_breath()


func on_attack():
	attacking = true   ## NOTE - Disabling this adds a pretty kickass gameplay speed for attacking, could be a potion effect
	camera_base.modify_breath(-7.0, 7.0, -7.0, 7.0, 0.1)


func on_gather():
	gathering = true
	camera_base.modify_breath(-7.0, 7.0, -7.0, 7.0, 0.1)


func on_action_1():
	# TODO - This fireball code should be on its own or somewhere else
	# WARN - For now, for simplicity, I will hardcode it here.
	prepare_spell()


func on_action_2():
	print("Action 2!")


## NOTE - What if spells have 2 phases: preparation and execution.
## During preparation the initial animation runs, placement prop, aiming, all that;
## while execution means the shooting of the projectile or spell, its effects being
## applied to entities within an area or a certain singular target, etc.
# TODO - This fireball code should be on its own or somewhere else
# WARN - For now, for simplicity, I will hardcode it here.
## WARN - DRY, what about prepare_spell(StringName: spell) ? 
func prepare_spell():
	if obj_in_hand: remove_object_in_hand()  # remove whatever is currently held first
	obj_in_hand = Cast.spell[GameEnums.SPELLS.FIREBALL].instantiate()
	owner.add_child(obj_in_hand)  # owner is optional, but might be useful later.
	aiming = true


func confirm_action():
	# TODO - This might grow more complex, not just for fireballs/projectiles.
	LevelManager.spawn(obj_in_hand, owner)
	obj_in_hand.z_index = 3
	obj_in_hand.life.start(obj_in_hand.base_stats[GameEnums.PROJECTILE.LIFE_TIME])
	obj_in_hand.shoot(get_global_mouse_position())
	aiming = false
	
	clear_hands()


## TODO - This needs a better name
func clear_hands():
	obj_in_hand = null


func remove_object_in_hand():
	obj_in_hand.queue_free()
	obj_in_hand = null


#func on_attack_finished():
	#pass
	# NOTE - Better to control this with the animation's signals
	# NOTE - Will leave this function here in case it's useful for buffs or something else
	#attacking = false
	#camera_base.modify_breath(-2.0, 2.0, -4.0, 4.0, 1.0)


#func on_gather_finished():
	#gathering = false
	#camera_base.modify_breath(-2.0, 2.0, -4.0, 4.0, 1.0)


##### DIALOGUE #####
## WARN - Came across game-breaking bugs with Dialogic. I reported the bugs, tested them
## to try and help, and see if they get fixed soon. For now, I should move on to other
## features until these get fixed first.
func _on_dialogue_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Speaker") and body not in speakers:
		speakers.append(body)


func _on_dialogue_area_body_exited(body: Node2D) -> void:
	if body in speakers:
		speakers.erase(body)


func run_dialogue(dialogue):
	## TODO - If multiple speakers nearvy, choose the closest one maybe.
	is_talking = true
	Dialogic.start(dialogue)


func dialogic_signal(arg: String):
	if arg == "exit_test":
		is_talking = false


func _on_torso_animator_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name.begins_with("roll"):
		rolling = false
		camera_base.modify_breath(-2.0, 2.0, -4.0, 4.0, 1.0)


func _on_torso_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name.begins_with("attack"):
		attacking = false
		camera_base.modify_breath(-2.0, 2.0, -4.0, 4.0, 1.0)
	elif anim_name.begins_with("gather"):
		gathering = false
		camera_base.modify_breath(-2.0, 2.0, -4.0, 4.0, 1.0)


func _on_area_trigger_area_entered(area: Area2D) -> void:
	if area.is_in_group("Door"):
		LevelManager.call_deferred("move_player", player, area)
