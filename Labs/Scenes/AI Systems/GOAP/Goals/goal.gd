class_name GoapGoal extends Node


# This indicates if the goal should be considered or not.
# Sometimes, instead of changing the priority, it is easier to
# not even consider the goal. i.e. Ignore combat related goals
# when there are not enemies nearby.
func is_valid(_agent) -> bool:
	## TODO - I think the logic for this was skipped, but the idea is here
	return true


# Returns the goal's priority. This priority can be dynamic.
func priority(_agent) -> int:
	## NOTE - I think the idea of using a function instead of a variable here
	## is that I can check world states that might affect the priority here.
	## A nice tradeoff for the tiny overhead it adds, will be useful, cleaner.
	return 1


# Plan's desired state. This is usually referred as 'desired world state,'
# but it doesn't need to match the raw world state.
#
# Example: in your world state you may store "hunger" as a number, but inside
# your goap you can deal with it as "is_hungry"
func get_desired_state() -> Dictionary:
	return {}
