@icon("res://Labs/Assets/X. Other/Icons/goap.svg")
class_name HumanAiGoap extends Node
## Controls the flow of execution of the entire behavior tree.

enum { SUCCESS, FAILURE, RUNNING }
enum ProcessThread { IDLE, PHYSICS }

signal tree_enabled
signal tree_disabled

var _last_tick : int = 0
var _goals : Array[GoapGoal] = []
var _current_goal : GoapGoal = null
var _current_plan
var _current_plan_step = 0

@export var _actor : HumanoidAIControllerComponent = null

## Whether this behavior tree should be enabled or not.
@export var _enabled : bool = true:
	set(value):
		_enabled = value
		set_physics_process(_enabled and _process_thread == ProcessThread.PHYSICS)
		set_process(_enabled and _process_thread == ProcessThread.IDLE)
		if value:
			tree_enabled.emit()
		else:
			interrupt()
			tree_disabled.emit()
	get:
		return _enabled

## How often the tree should tick, in frames. The default value of 1 means
## tick() runs once every frame. A value of 60 means tick() runs once every 60 frames.
@export var _tick_rate : int = 1

## Whether to run this tree in a physics or idle thread.
@export var _process_thread : ProcessThread = ProcessThread.PHYSICS:
	set(value):
		_process_thread = value
		set_physics_process(_enabled and _process_thread == ProcessThread.PHYSICS)
		set_process(_enabled and _process_thread == ProcessThread.IDLE)


func _ready() -> void:
	set_physics_process(_enabled and _process_thread == ProcessThread.PHYSICS)
	set_process(_enabled and _process_thread == ProcessThread.IDLE)
	
	# Randomize at what frames tick() will happen to avoid stutters
	_last_tick = randi_range(0, _tick_rate - 1)


# Setup GOAP's goals based on the entity's personality roles & their goals
func setup():
	for personality_role in _actor.personality.roles:
		_goals.append_array(personality_role.goals)
		# DEBUG FOR MULTIPLE GOALS IN ONE ROLE:
		#for goal in _goals:
			#print("GOAL +++++++++ ", goal.get_class_name())


# Runs at an inconsistent amount of frames per second. Dynamic Tick System.
# WARNING NOTE - If using the 'idle' mode, that is, running at the same amount of frames
# as the game is currently running (instead of the fixed 60fps in '_physics_process, 'Physics' mode),
# this can make the GOAP run either more times (if >60fps), or less (if <60fps) per second,
# essentially making the NPC 'smarter' or 'dumber' given the current FPS. This is more dynamic, but
# might be problematic, as fps are not consistent all the time. This can be useful in some cases.
func _process(delta: float) -> void:
	_process_internally(delta)


# Runs 60 times per second no matter what. Static Tick System.
# This consistency gives more control and predictability over the tick system.
func _physics_process(delta: float) -> void:
	_process_internally(delta)


func _process_internally(delta: float) -> void:
	if _last_tick < _tick_rate - 1:
		_last_tick += 1
		return
	
	_last_tick = 0
	tick(delta)
	## DEBUG - For debugging and a future metrics feature to measure performance, bottlenecks...
	## Start timing for metric  ## WARN - Might come in handy in the future, don't delete
	#var start_time = Time.get_ticks_usec()
	
	#blackboard.set_value("can_send_message", _can_send_message)  ## WARN - Might not need this
	
	#if _can_send_message:            ## WARN - Might not need this
		#BeehaveDebuggerMessages.process_begin(get_instance_id())
		
	#if self.get_child_count() == 1:  ## WARN - Think it's an exclusive requirement for BTs
		#tick()
		
	#if _can_send_message:            ## WARN - Might not need this
		#BeehaveDebuggerMessages.process_end(get_instance_id())
		
	## Check the cost for this frame and save it for metric report.
	## WARN - Might come in handy in the future, DO NOT delete yet.
	#_process_time_metric_value = Time.get_ticks_usec() - start_time


func tick(delta: float):
	var goal = _get_best_goal()
	if _current_goal == null or goal != _current_goal:
		## TODO - Might need a system for modifying, updating, cleaning the blackboard
		## mid calculations. It's used to take in account variables of interest during
		## the planning phase of the GOAP.
		var blackboard = {
			"global_position" : _actor.global_position,
		}
	
		for s in WorldState.states:
			## WARNING TODO - Adapt this to a local WorldState, not an autoload as the original
			## TODO - Maybe clean the blackboard first, to reduce overhead?
			## World_States does the same with its states, "func clear_states()"
			blackboard[s] = WorldState.states[s]
		
		_current_goal = goal
		_current_plan = Goap.get_action_planner().get_plan(_current_goal, blackboard)
		_current_plan_step = 0
		#_follow_plan(_current_plan, delta) # WARN - Might need to run here to avoid waiting a tick
	else:
		_follow_plan(_current_plan, delta)


# Returns the highest priority goal available.
func _get_best_goal() -> GoapGoal:
	var highest_priority_goal : GoapGoal = null
	
	for goal in _goals:
		if goal.is_valid() and (highest_priority_goal == null or goal.priority() > highest_priority_goal.priority()):
			highest_priority_goal = goal
	
	return highest_priority_goal


# Executes the plan. This function is called on every tick.
# "plan" is the current list of actions, and delta is the time since last loop.
#
# Every action exposes a function called perform, which will return true when
# the job is complete, so the agent can jump to the next action in the list.
func _follow_plan(plan, delta):
	if plan.size() == 0:
		return
	
	var is_step_complete = plan[_current_plan_step].perform(_actor, delta)
	if is_step_complete and _current_plan_step < plan.size() - 1:
		_current_plan_step += 1


## interrupts this tree if anything was running
## TODO - Probably adapt this to the needed system.
## "Save" or "Remember, memorize" what plan the entity was doing to resume later.
func interrupt() -> void:
	pass
	#if self.get_child_count() != 0:
		#var first_child = self.get_child(0)
		#if "interrupt" in first_child:
			#first_child.interrupt(actor, blackboard)


## Enables this tree.
func enable() -> void:
	self._enabled = true


## Disables this tree.
func disable() -> void:
	self._enabled = false


func get_class_name() -> Array[StringName]:
	return [&"HumanAiGoap"]
