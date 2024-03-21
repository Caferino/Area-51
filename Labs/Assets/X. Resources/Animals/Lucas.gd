class_name Companion extends CharacterBody2D

@onready var sprite = $Sprite
@export var movement_speed: float = 50.0
@export var target_character: CharacterBody2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent


func _ready():
	#set_physics_process(false)  # Useless, delete, didn't work
	#await get_tree().physics_frame
	#set_physics_process(true)
	sprite.play("move")
	#navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))


func _physics_process(_delta):
	move_and_slide()
	#set_movement_target(target_character.global_position)
	#
	#if navigation_agent.is_navigation_finished():
		#return
	#
	#var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	#var current_agent_position: Vector2 = global_position
	#var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * movement_speed
	#
	handle_animation()
	#
	#if navigation_agent.avoidance_enabled:
		#navigation_agent.set_velocity(new_velocity)
	#else:
		#_on_velocity_computed(new_velocity)


var is_moving = false
const RADIUS = 5
@export var behavior = 0  # 0: follow, 1: away
func set_movement_target(movement_target: Vector2):
	if behavior == 0:
		navigation_agent.set_target_position(movement_target)
	
	if behavior == 1 and is_moving:
		pass # TODO - var new_position = get_opposite_point(global_position.x, globaal_position.y, RADIUS, movement_target.x, movement_target.y)
		# navigation_agent.set_target_position(new_position)


func get_opposite_point(cx, cy, radius, x, y):
	var v = Vector2(x - cx, y - cy)
	var nv = v.normalized()
	var op = Vector2(cx - radius * nv.x, cy - radius * nv.y)
	
	return Vector2(op.x, op.y)


func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()


# ===== ANIMATION SECTION =====
@export var animation_column = 0
@export var facing = 0
const NUM_DIRECTIONS = 4
const AWAY = 3
const TOWARDS = 0
const LEFT = 1
const RIGHT = 2


var animation_change_snappiness = 0.5
func handle_animation():
	if velocity == Vector2.ZERO:
		sprite.play("idle")
	else:
		sprite.play("move")
	if velocity.x > animation_change_snappiness:
		sprite.flip_h = false
	if velocity.x < -animation_change_snappiness:
		sprite.flip_h = true

