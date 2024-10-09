class_name CollectWoodAction extends GoapAction

## WARNING NOTE - I think the original author never used the wood_stocks he made,
## although he was close to, he kinda coded everything for them, but never got used.

func get_class_name(): return "CollectWoodAction"

func is_valid() -> bool:
	# Adapt this for the game, should probably check the entity's inventory
	return true
	#return WorldState.get_elements("wood").size() > 0


func get_cost(blackboard) -> int:
	if blackboard.has("position"):
		# TODO - ADAPT THIS
		return 5
		#var closest_tree = WorldState.get_closest_element("wood", blackboard)
		#return int(closest_tree.position.distance_to(blackboard.position) / 5)
	return 5


func get_preconditions() -> Dictionary:
	return {
		"dropped_wood" : true
	}


func get_effects() -> Dictionary:
	return {
		"has_wood" : true
	}


func perform(actor, delta) -> bool:
	# WARN - Most likely Deprecated, I don't use wood_stocks, just picked up wooden logs.
	var closest_stock = WorldState.get_closest_element("wood_stock", actor)
	
	# WARN - This will be dangerous if the player or anyone affects anyone's state
	# The NPC might not have 5 logs in his inventory, but if you do, this state turns true,
	# potentially confusing the NPC's current goal with a lie.
	# TODO - This is why every NPC should have its own WorldStates or something.
	#if entity's inventory["Logs"] > 4 : WorldState.set_state("has_wood", true)
	
	
	## WARN - Most likely Deprecated
	if closest_stock:
		if closest_stock.position.distance_to(actor.position) < 10:
			closest_stock.queue_free()
			WorldState.set_state("has_wood", true)
			return true
		else:
			# TODO - Might have to adapt this to send dir to the entity's AI controller
			actor.move_to(actor.position.direction_to(closest_stock.position), delta)
	
	return false
