class_name ChoppedWoodGoal extends GoapGoal

func get_class_name(): return "ChoppedWoodGoal"

func is_valid(_agent) -> bool:
	## WARN - If there is no wood in the ground, this will break. It needs a dynamic valid check 
	# TODO - What if I want him to chop and never collect? Might need to create permissions
	# Maybe a boolean state "chop_endlessly" that's checked here with an OR
	# or create a goal that somehow makes him ignore "collect_wood"
	# or give him an insane amount of "need_wood", like 1,000. Be careful with this one
	# which of these is the closest to reality?
	# TODO - Also, to avoid so many calls, might add a blackboard param where I calculate these
	# values and booleans before coming here, because goddamn, look at the size of this thing
	#return agent.get_elements("Tree").size() > 0# and agent.controller.entity.inventory.items["Logs"] + agent.get_elements("Wood").size() < agent.states["need_wood"]
	return true


func priority(agent) -> int:
	return agent.states["chopped_wood_priority"]


func get_desired_state() -> Dictionary:
	return {
		"chopped_wood": true
	}
