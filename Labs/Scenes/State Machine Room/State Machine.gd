class_name StateMachine extends Node

@export var initial_state : State

const distance_tolerance = 120   # The area Lucas will idle/play around you
var target_last_position = Vector2()
var current_state : State
var states : Dictionary = {}
@onready var timer = $Timer


func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(_on_child_transition)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state


func _process(delta):
	if current_state:
		current_state.Update(delta)


func _physics_process(delta: float):
	if current_state:
		current_state.State_Process(delta)


func _update_current_state(new_state):
	current_state = new_state


func _on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	_update_current_state(new_state)

