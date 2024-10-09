class_name GoapAgent extends Node
# This script integrates the actor (NPC) with GOAP.

var _goals
var _current_goal
var _current_plan
var _current_plan_step = 0
var _actor

# On every loop this script checks if the current goal is still
# the highest priority. If it's not, it requests the action planner a new plan
# for the new high priority goal.
#
# NOTE - Might tie this to the Tick System instead, to have more control
# over the CPU or resources maybe.
func _process(delta):
	var goal = _get_best_goal()
	if _current_goal == null or goal != _current_goal:
		# You can set in the blackboard any relevant information you want to use
		# when calculating action costs and status.
		# NOTE - Might need to be moved
		var blackboard = {
			"position" : _actor.position,
		}
		
		for s in WorldState._state:
		# WARNING - Adapt this to a local WorldState, not an autoload as the original
			blackboard[s] = WorldState._state[s]
		
		_current_goal = goal
		# WARNING - Adapt this to a local Goap, not an autoload as the original
		_current_plan = Goap.get_action_planner().get_plan(_current_goal, blackboard)
		_current_plan_step = 0
	else:
		_follow_plan(_current_plan, delta)


func init(actor, goals: Array):
	_actor = actor
	_goals = goals


# Returns the highest priority goal available.
func _get_best_goal():
	var highest_priority_goal
	
	for goal in _goals:
		if goal.is_valid() and (highest_priority_goal == null or goal.priority() > highest_priority_goal.priority()):
			highest_priority_goal = goal
	
	return highest_priority_goal


# Executes the plan. This function is called on every TODO - game loop/tick.
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
