class_name GoapAction extends Node


# Indicates if the action should be considered or not.
# Could also be used during execution to abort the plan in case 
# the world state does not allow this action anymore.
func is_valid() -> bool:
	return true


# Handles situational costs when the world state is considered
# when calculating the cost.
func get_cost(_blackboard) -> int:
	return 1000


# Action requirements.
# Example:
# {
#   "has_wood": true
# }
func get_preconditions() -> Dictionary:
	return {}


# The conditions this action satisfies.
# Example:
# {
#   "has_wood": true
# }
func get_effects() -> Dictionary:
	return {}


# Action implementation called on every loop.
# "actor" is the NPC using the AI
# "delta" is the time in seconds since last loop.
#
# Returns true when the task is complete
#
# NOTE - I decided to have actions owning their logic, but this
# is up to you. You could have another script to handle this
# or even let your NPC decide how to handle the action. In other words,
# your NPC could just receive the action name and decide what to do.
func perform(_actor, _delta) -> bool:
	return false
