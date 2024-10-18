class_name BuildFirepitGoal extends GoapGoal

func get_class_name(): return "BuildFirepitGoal"

func is_valid(_agent) -> bool:
	return true


func priority(agent) -> int:
	return agent.states["has_firepit"]


func get_desired_state() -> Dictionary:
	return {
		"has_firepit": true
	}
