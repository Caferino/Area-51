class_name PlayerControllerComponent extends Node

signal player_interact()
signal player_moved()
signal attacked

@export var interactor          : Marker2D
@export var interactor_area     : Area2D
@export var interactor_animator : AnimationTree

var dir                 = Vector2()
var anim_state          = "Move"
var is_attacking        = false
var is_sprinting        = false


func _physics_process(_delta: float) -> void:
	if !is_attacking:
		check_movement()


func _input(_event):
	if !is_attacking:
		if Input.is_action_just_pressed("attack"):
			attacked.emit()
		elif Input.is_action_just_pressed("interact"):
			player_interact.emit()


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
	
	emit_signal("player_moved")


func rotate_interactor(position, direction):
	interactor.position = position
	interactor_animator["parameters/Movement/blend_position"] = direction
