class_name PlayerControllerComponent extends Node2D
## The entity's [color=gold]player controller.

signal player_move()      ## Emitted whenever the player gives movement input ([kbd]'W' 'A' 'S' 'D'[/kbd])
signal player_attack()    ## Emitted whenever the player gives attack input ([kbd]Left-Click[/kbd]).
signal player_interact()  ## Emitted whenever the player gives interact input ([kbd]'F'[/kbd]).

@export var camera_base         : CameraBase     ## The player's camera base.
@export var interactor_area     : Area2D         ## The interactor's monitoring area.
@export var interactor_animator : AnimationTree  ## The interactor's animator (for rotation).
# WIP @export var looting_area        : Area2D         ## The player's looting pick-up range.

var dir              : Vector2  = Vector2()  ## Current direction.
var anim_state       : String   = "Move"     ## Current animation state.
var is_attacking     : bool     = false      ## Is the entity currently attacking?
var is_sprinting     : bool     = false      ## Is the entity currently sprinting?
var is_moving        : bool     = false      ## Is the entity currently moving?


## Checks whether the player is giving movement input every physics frame.
func _physics_process(_delta: float) -> void:
	if !is_attacking:
		check_movement()


## Runs whenever there is an [InputEvent] to check whether it's an attack or interaction.
func _input(_event: InputEvent):
	if !is_attacking:
		if Input.is_action_just_pressed("attack"):
			player_attack.emit()
		elif Input.is_action_just_pressed("interact"):
			player_interact.emit()


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
		if !is_moving: 
			is_moving = true
			player_move.emit()
		
		dir = dir.normalized()
		
		if Input.is_action_pressed("sprint"):
			is_sprinting = true
			anim_state   = "Run"
		else:
			is_sprinting = false
			anim_state   = "Move"
	else:
		is_moving = false


## Rotates the interactor's [member Marker2D.rotation].
func rotate_interactor(direction: Vector2):
	interactor_animator["parameters/Movement/blend_position"] = direction


## Stops the camera shake.
func stop():
	print("Stopping camera shake")
	# TODO Could just increase/return back to normal the random stats
