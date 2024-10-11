class_name BuildFirepitAction extends GoapAction

# TODO - CHANGE IT, no idea where did this one come from...
const Firepit = preload("res://Labs/Scenes/Interactables/firepit/firepit.tscn")

func get_class_name(): return "BuildFirepitAction"

func is_valid(_agent) -> bool:
	# Adapt this for the game, should probably check the entity's inventory
	# TODO - Check if the NPC has the needed items to craft and place a firepit
	return true


func get_cost(_agent) -> int:
	return 1


func get_preconditions() -> Dictionary:
	return {
		"has_wood" : true
	}


func get_effects() -> Dictionary:
	return {
		"has_firepit" : true
	}


func perform(agent, delta) -> bool:
	print("Performing build_firepit!")
	var _closest_spot = agent.get_closest_element("firepit_spot", agent)
	
	if _closest_spot == null:
		return false
	
	if _closest_spot.position.distance_to(agent.position) < 20:
		var firepit = Firepit.instantiate()
		agent.get_parent().add_child(firepit)
		firepit.position = _closest_spot.position
		firepit.z_index = _closest_spot.z_index
		agent.set_state("has_wood", false)
		return true
	
	# TODO - Adapt this to send dir to the entity's controller
	agent.move_to(agent.position.direction_to(_closest_spot.position), delta)
	return false
