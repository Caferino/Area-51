class_name KeepFirepitBurningGoal extends GoapGoal

func get_class_name(): return "KeepFirepitBurningGoal"

func is_valid(_agent) -> bool:
	return true
	## TODO - Adapt this, I don't use woodstocks
	#return WorldState.get_elements("firepit").size() == 0


func priority(_agent) -> int:
	return 1


func get_desired_state() -> Dictionary:
	return {
		"has_firepit": true
	}
