# This class is an autoload accessible globally.
# It initialises a GoapActionPlanner with the available actions.
#
# In your game, you might want to have different planners for different enemy/npc types,
# and even change the set of actions in runtime.
#
# This example keeps things simple, creating only one planner with pre-defined actions.
# WARNING TODO - Redo this. Might not be global, and it shouldn't start with pre-defined actions.

## ATTENTION - This entire file, code has become DEPRECATED.
## It now exists inside human_ai_goap or any other entity's ai_goap system.
## The actions (and goals) are setup through the entity's unique personality.
## Therefor, this entire code is not needed anymore, but will leave it just in case, for a while.
extends Node

var _action_planner = GoapActionPlanner.new()

# WARN - This is a simplified general version for a tutorial example
# NOTE - The main functionality is, actions with costs, effects, planner...
func _ready():
	_action_planner.set_actions([
		ChopTreeAction.new(),
		CollectWoodAction.new(),
		BuildFirepitAction.new(),
		#CalmDownAction.new(),               # Maybe delete
		#FindCoverAction.new(),              # Maybe delete
		#FindFoodAction.new(),               # Maybe delete
	])


func get_action_planner() -> GoapActionPlanner:
	return _action_planner
