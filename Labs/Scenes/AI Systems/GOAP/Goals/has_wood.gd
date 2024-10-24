class_name HasWoodGoal extends GoapGoal

func get_class_name(): return "HasWoodGoal"

func is_valid(_agent) -> bool:
	return true


func priority(agent) -> int:
	return agent.states["has_wood_priority"]


func get_desired_state() -> Dictionary:
	return {
		"has_wood": true
	}
