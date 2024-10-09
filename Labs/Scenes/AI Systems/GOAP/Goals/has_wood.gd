class_name HasWoodGoal extends GoapGoal

func get_class_name(): return "HasWoodGoal"

func is_valid() -> bool:
	return true
	## TODO - Adapt this
	#return WorldState.get_elements("firepit").size() == 0


func priority() -> int:
	return 1


func get_desired_state() -> Dictionary:
	return {
		"has_wood": true
	}
