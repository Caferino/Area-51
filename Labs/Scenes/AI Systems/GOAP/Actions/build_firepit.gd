class_name BuildFirepitAction extends GoapAction

# TODO - CHANGE IT, no idea where did this one come from...
const Firepit = preload("res://Labs/Scenes/Utility AI Example/objects/firepit.tscn")

func get_class_name(): return "BuildFirepitAction"

func is_valid() -> bool:
	# Adapt this for the game, should probably check the entity's inventory
	# TODO - Check if the NPC has the needed items to craft and place a firepit
	return true


func get_cost(_blackboard) -> int:
	return 1


func get_preconditions() -> Dictionary:
	return {
		"has_wood" : true
	}


func get_effects() -> Dictionary:
	return {
		"has_firepit" : true
	}


func perform(actor, delta) -> bool:
	var _closest_spot = WorldState.get_closest_element("firepit_spot", actor)
	
	if _closest_spot == null:
		return false
	
	if _closest_spot.position.distance_to(actor.position) < 20:
		var firepit = Firepit.instantiate()
		actor.get_parent().add_child(firepit)
		firepit.position = _closest_spot.position
		firepit.z_index = _closest_spot.z_index
		WorldState.set_state("has_wood", false)
		return true
	
	# TODO - Adapt this to send dir to the entity's controller
	actor.move_to(actor.position.direction_to(_closest_spot.position), delta)
	return false
