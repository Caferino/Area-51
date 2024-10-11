class_name CollectWoodAction extends GoapAction

## WARNING NOTE - I think the original author never used the wood_stocks he made,
## although he was close to, he kinda coded everything for them, but never got used.

func get_class_name(): return "CollectWoodAction"

func is_valid(_agent) -> bool:
	# Adapt this for the game, should probably check the entity's inventory
	return true
	#return WorldState.get_elements("wood").size() > 0


func get_cost(agent) -> int:
	if agent._states.has("global_position"):
		# TODO - ADAPT THIS
		return 5
		#var closest_tree = WorldState.get_closest_element("wood", blackboard)
		#return int(closest_tree.global_position.distance_to(blackboard.global_position) / 5)
	return 5


func get_preconditions() -> Dictionary:
	return {
		"dropped_wood" : true
	}


func get_effects() -> Dictionary:
	return {
		"has_wood" : true
	}


func perform(agent, delta) -> bool:
	print("Performing collect_wood!")
	# WARN - Most likely Deprecated, I don't use wood_stocks, just picked up wooden logs.
	var closest_stock = WorldState.get_closest_element("wood_stock", agent)
	
	# WARN - This will be dangerous if the player or anyone affects anyone's state
	# The NPC might not have 5 logs in his inventory, but if you do, this state turns true,
	# potentially confusing the NPC's current goal with a lie.
	# TODO - This is why every NPC should have its own WorldStates or something.
	#if entity's inventory["Logs"] > 4 : WorldState.set_state("has_wood", true)
	
	
	## WARN - Most likely Deprecated
	if closest_stock:
		if closest_stock.position.distance_to(agent.global_position) < 10:
			closest_stock.queue_free()
			agent.set_state("has_wood", true)
			return true
		else:
			pass
			# TODO - Might have to adapt this to send dir to the entity's AI controller
			# WARN - Adapt this, using move_to is wrong in my game. Give dir to the controller.
			#goap.move_to(actor.position.direction_to(closest_stock.global_position), delta)
	
	return false
