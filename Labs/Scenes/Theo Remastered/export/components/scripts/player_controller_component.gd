class_name PlayerControllerComponent extends Node
## The entity's [color=gold]player controller.

signal player_move()      ## Emitted whenever the player gives movement input: ([kbd]'W' 'A' 'S' 'D'[/kbd]).
signal player_attack()    ## Emitted whenever the player gives attack input ([kbd]Left-Click[/kbd]).
signal player_interact()  ## Emitted whenever the player gives interact input ([kbd]'F'[/kbd]).

@export var interactor          : Marker2D       ## The interactor's origin point (for rotation).
@export var interactor_area     : Area2D         ## The interactor's monitoring area.
@export var interactor_animator : AnimationTree  ## The interactor's animator (for rotation).

var dir                 = Vector2()  ## Current direction.
var anim_state          = "Move"     ## Current animation state.
var is_attacking        = false      ## Is the entity currently attacking?
var is_sprinting        = false      ## Is the entity currently sprinting?


## Checks whether the player is giving movement input every physics frame.
func _physics_process(_delta: float) -> void:
	if !is_attacking:
		check_movement()


## Runs whenever there is an [InputEvent] to check whether it's an attack or interaction.
func _input(event):
	if !is_attacking:
		if event.is_action("attack"):
			player_attack.emit()
		elif event.is_action("interact"):
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
	
	dir = dir.normalized()
	
	if Input.is_action_pressed("sprint"):
		is_sprinting = true
		anim_state   = "Run"
	else:
		is_sprinting = false
		anim_state   = "Move"
	
	player_move.emit()


## Rotates the interactor's [member Marker2D.rotation].
func rotate_interactor(position, direction):
	interactor.position = position
	interactor_animator["parameters/Movement/blend_position"] = direction
