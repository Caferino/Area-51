@icon("res://Labs/Assets/X. Other/Icons/goap.svg")
class_name HumanAiGoap extends Node
## A humanoid [color=brown]Goal-Oriented Action Planner AI.

enum { SUCCESS, FAILURE, RUNNING }
enum ProcessThread { IDLE, PHYSICS }

signal tree_enabled
signal tree_disabled

var states             : Dictionary        = {}    ##
var _current_goal      : GoapGoal          = null  ##
var _last_tick         : int               = 0     ##
var _goals             : Array[GoapGoal]   = []    ##
var _actions           : Array[GoapAction] = []    ##
var _current_plan      : Array             = []    ##
var _current_plan_step : int               = 0     ##
var goal_complete      : bool              = false  ##

@export var gbl_timer      : Timer                         = null  ## Global timer for general use.
@export var controller     : HumanoidAIControllerComponent = null  ## The AI's main controller.
@export var detection_area : Area2D                        = null  ## A line of sight for props.

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

func get_class_name() -> Array[StringName]: return [&"HumanAiGoap"]

## Setup GOAP's goals based on the entity's personality roles & their goals
func setup():
	for personality_role in controller.personality.roles:
		_goals.append_array(personality_role.goals)
		_actions.append_array(personality_role.actions)
		for state in personality_role.states:
			states[state] = personality_role.states[state]
		# DEBUG FOR MULTIPLE GOALS IN ONE ROLE:
		#for goal in _goals:
			#print("GOAL +++++++++ ", goal.get_class_name())


## Prepares the given process mode and the random tick rate interval.
func _ready() -> void:
	set_physics_process(_enabled and _process_thread == ProcessThread.PHYSICS)
	set_process(_enabled and _process_thread == ProcessThread.IDLE)
	
	# Randomize at what frames tick() will happen to avoid stutters
	_last_tick = randi_range(0, _tick_rate - 1)


## Runs at an inconsistent amount of frames per second. Dynamic Tick System.
## WARNING NOTE - If using the 'idle' mode, that is, running at the same amount of frames as the
## game is currently running (instead of the fixed 60fps in '_physics_process, 'Physics' mode),
## this can make the GOAP run either more times (if >60fps), or less (if <60fps) per second,
## essentially making the NPC 'smarter' or 'dumber' given the current FPS. This is more dynamic, but
## might be problematic, as fps are not consistent all the time. This can be useful in some cases.
func _process(delta: float) -> void:
	_process_internally(delta)


## Runs 60 times per second no matter what. Static Tick System.
## This consistency gives more control and predictability over the tick system.
func _physics_process(delta: float) -> void:
	_process_internally(delta)


## Checks whether it's time to execute a tick.
## (Optional) Holds the debugging frame to measure the tick's process time taken.
func _process_internally(delta: float) -> void:
	if _last_tick < _tick_rate - 1:
		_last_tick += 1
		return
	
	_last_tick = 0
	tick(delta)
	## DEBUG - For debugging and a future metrics feature to measure performance, bottlenecks...
	## Start timing for metric  ## WARN - Might come in handy in the future, don't delete
	#var start_time = Time.get_ticks_usec()
	#tick(delta)  # WARN - Only one tick, don't forget to comment the one above.
	#_process_time_metric_value = Time.get_ticks_usec() - start_time


## Checks whether there is a better goal to do. If there is one, it fetches a plan
## given by the planner below to start working on it.
## NOTE - Fused world_states.gd, agent.gd and planner.gd altogether here.
## This allows me to send the goap to is_valid() and therefore avoid the need
## for a global class (like world_states.gd) to get the nearest elements.
## I can now use the NPC's DetectionArea to avoid looping through all the
## interactive items in the entire level like world_states.gd was doing it.
## It makes the NPC more dynamic, adaptable and independent.
func tick(delta: float):
	var best_goal = _get_best_goal()
	if goal_complete:
		goal_complete = false
		controller.switch_ai()
	elif _current_goal == null or best_goal != _current_goal:
		_current_goal = best_goal
		_current_plan = get_plan(_current_goal)
		_current_plan_step = 0
		_follow_plan(_current_plan, delta)  # To avoid waiting until next tick
	else:
		_follow_plan(_current_plan, delta)


## Returns the highest priority goal available.
func _get_best_goal() -> GoapGoal:
	var highest_priority_goal : GoapGoal = null
	
	for goal in _goals:
		if goal.is_valid(self) and (highest_priority_goal == null or 
		goal.priority(self) > highest_priority_goal.priority(self)):
			highest_priority_goal = goal
	
	return highest_priority_goal


## Executes the plan. This function is called on every tick.
## "plan" is the current list of actions, and delta is the time since last loop.
## [br][br]
## Every action exposes a function called perform, which will return true when
## the job is complete, so the agent can jump to the next action in the list.
## TODO - Inside tick(), I need a way to return to the BehaviorTree
func _follow_plan(plan, delta):
	if plan.size() == 0:
		return
	
	var is_step_complete = plan[_current_plan_step].perform(self, delta)
	if is_step_complete and _current_plan_step < plan.size():
		_current_plan_step += 1
		print("Current plan step = ", _current_plan_step)
	if _current_plan_step == plan.size():
		## WARN TODO - I think I will need to reset priorities and more
		_current_plan_step = 0
		goal_complete = true


## Interrupts this tree if anything was running
## TODO - Probably adapt this to the needed system.
## "Save" or "Remember, memorize" what plan the entity was doing to resume later.
func interrupt() -> void:
	pass


## Enables this tree.
func enable() -> void:
	self._enabled = true


## Disables this tree.
func disable() -> void:
	self._enabled = false




###########################################
##   ___  _    ___  _ _  _ _  ___  ___   ##
##  | . \| |  | . || \ || \ || __>| . \  ##
##  |  _/| |_ |   ||   ||   || _> |   /  ##
##  |_|  |___||_|_||_\_||_\_||___>|_\_\  ##
###########################################

## Receives a goal and an optional blackboard.
## Returns a list of actions to be executed.
func get_plan(goal: GoapGoal = null):
	var desired_state = goal.get_desired_state().duplicate()
	
	if desired_state.is_empty():
		return []
	
	return _find_best_plan(goal, desired_state)


## Finds the best possible available plan given the highest-priority goal.
func _find_best_plan(goal: GoapGoal = null, desired_state: Dictionary = {}):
	# goal is set as root action. Feels weird, but the code is simpler this way.
	var root = {
		"action"   : goal,
		"state"    : desired_state,
		"children" : []
	}
	
	# _build_plans will populate root with children.
	# In case it doesn't find a valid a path, it will return false.
	if _build_plans(root):
		var plans = _transform_tree_into_array(root)
		return _get_cheapest_plan(plans)
	
	return []


## Builds a graph with actions. Only includes valid plans
## (plans that achieve the goal).
## Returns true if the path has a solution.
## [br][br]
## This function uses recursion to build the graph.
## This is necessary because any new action included in the graph may
## add pre-conditions to the desired state that can be satisfied
## by previously considered actions, meaning, on every step we
## need to iterate from the beginning to find all the solutions.
##
## WARNING TODO - Be aware that, for simplicity, the current implementation is
## not protected from circular dependencies. This is easy to implement, though.
func _build_plans(step):
	var has_followup = false
	
	# Each node in the graph has its own desired state.
	var state = step.state.duplicate()
	# Check if the states contains data that can satisfy the current state
	for s in step.state:
		if state[s] == states.get(s):
			state.erase(s)
	
	# If the state is empty, it means this branch already found the solution,
	# so it doesn't need to look for more actions
	if state.is_empty():
		return true
	
	for action in _actions:
		print("Calling action here! ", _actions)
		if not action.is_valid(self):
			continue
		
		var should_use_action = false
		var effects = action.get_effects()
		var desired_state = state.duplicate()
		
		# Check if the action should be used, i.e. it satisfies
		# at least one condition from the desired state.
		for s in desired_state:
			if desired_state[s] == effects.get(s):
				desired_state.erase(s)
				should_use_action = true
		
		if should_use_action:
			# Adds actions' pre-conditions to the desired state
			var preconditions = action.get_preconditions()
			for p in preconditions:
				desired_state[p] = preconditions[p]
			
			var s = {
				"action" : action,
				"state"  : desired_state,
				"children" : []
			}
			
			# If desired_state is empty, it means this action can be included in the graph.
			# If it's not empty, _build_plans is called again (recursively) so it can try to find
			# actions to satisfy this current state. In case it can't find anything, this action
			# won't be included in the graph.
			if desired_state.is_empty() or _build_plans(s):
				step.children.push_back(s)
				has_followup = true
	
	return has_followup


## Transforms the graph with actions into a list of actions and calculates the cost by
## summing their costs. Returns a list of plans.
func _transform_tree_into_array(p):
	var plans = []
	
	if p.children.size() == 0:
		plans.push_back({ "actions": [p.action], "cost": p.action.get_cost(self) })
		return plans
	
	for c in p.children:
		for child_plan in _transform_tree_into_array(c):
			if p.action.has_method("get_cost"):
				child_plan.actions.push_back(p.action)
				child_plan.cost += p.action.get_cost(self)
			plans.push_back(child_plan)
	
	return plans


## Compares the plans' costs and returns actions included in the cheapest one.
func _get_cheapest_plan(plans):
	var best_plan = null
	for p in plans:
		_print_plan(p)
		if best_plan == null or p.cost < best_plan.cost:
			best_plan = p
	return best_plan.actions


## For debugging.
func _print_plan(plan):
	var actions = []
	for a in plan.actions:
		actions.push_back(a.get_class_name())
	print({ "cost": plan.cost, "actions": actions })
	#WorldState.console_message({ "cost": plan.cost, "actions": actions })




#######################################################
##   SSSSS  TTTTTTT   AAA   TTTTTTT EEEEEEE  SSSSS   ##
##  SS        TTT    AAAAA    TTT   EE      SS       ##
##   SSSSS    TTT   AA   AA   TTT   EEEEE    SSSSS   ##
##       SS   TTT   AAAAAAA   TTT   EE           SS  ##
##   SSSSS    TTT   AA   AA   TTT   EEEEEEE  SSSSS   ##
#######################################################

func get_state(state_name, default = null):
	return states.get(state_name, default)


func set_state(state_name, value):
	states[state_name] = value


func clear_state():
	states = {}


## Returns all the scenes that belong to group_name in the current level.
func get_elements(group_name):
	return self.get_tree().get_nodes_in_group(group_name)


## WARNING - I thought I could get rid of the big loop that iterates through
## all the interactive objects of a certain group, however, I might have to do it
## regardless, and might even add extra overhead if I want to check if it overlaps
## with the NPC's DetectionArea, which kinda sucks. Maybe remove that check?
## ATTENTION - Get rid of DetectionArea completely? Can help for realism, but,
## adds overhead so far right now. Meditate this, find a solution.


## Seeks the nearest interactable or collectable item of the given group_name.
## NOTE TODO - Someday I could add a "how_many" parameter, or create a distinct 
## entire function "get_closest_elements" that returns the n closest items for 
## the NPC or AI to choose the best option, like a more suitable weapon.
## NOTE - Could also add a distance ref to each. Returning a list like that, 
## plus avoiding editing all the get_closest_elements" everywhere, a distinct 
## function might be a better idea, maybe. 
func get_closest_element(group_name, reference) -> Area2D:
	var elements = get_elements(group_name)
	var closest_element
	var closest_distance = 1000000000
	
	for element in elements:
		if detection_area.overlaps_area(element):
			var distance = reference.global_position.distance_to(element.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_element = element
	
	return closest_element
