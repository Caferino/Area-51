class_name PlayerControllerComponent extends Node

signal player_interacted()
signal player_moved()

var dir          = Vector2()
var anim_state   = "Move"
var is_attacking = false
var is_sprinting = false


## Handles inputs
func _process(_delta: float) -> void:
	if !is_attacking:
		check_movement()
		check_interact()


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


func check_interact():
	pass
	#if Input.is_action_just_pressed("interact"):
		#if interaction_area.get_overlapping_bodies():
			#interact()
		#if interaction_area.get_overlapping_areas():
			#pass
	#emit_signal("player_interacted")