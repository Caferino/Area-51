class_name CollectWoodAction extends GoapAction

## WARNING NOTE - I think the original author never used the wood_stocks he made,
## although he was close to, he kinda coded everything for them, but never got used.

var wood : Area2D = null

func get_class_name(): return "CollectWoodAction"

func is_valid(_agent) -> bool:
	# WARN - This may need to always return true, because what if it receives the
	# build_firepit order and already has the wood in its inventory? It will never
	# consider this action, and therefor will never build a plan because of this check
	#return agent.controller.entity.inventory.items["Logs"] < agent.states["need_wood"]
	# However, how to fix that? Create a check_wood action that does just one if
	# "The npc checks its inventory to verify it has the needed items"
	# has no preconditions, so it can be done anytime. Just the effects
	return true


func get_cost(_agent) -> int:
	return 1


func get_preconditions() -> Dictionary:
	return {
		"chopped_wood" : true
	}


func get_effects() -> Dictionary:
	return {
		"has_wood" : true
	}


func perform(agent, _delta) -> bool:
	print("Performing collect_wood!")
	## ATTENTION WARNING - Someday fix collectables that drop out of bounds, unreachable spots
	if agent.controller.entity.inventory.items["Logs"] >= agent.states["need_wood"]:
		print("COLLECT_WOOD ACTION SHOULD BE FINISHED NOW!")
		agent.controller.anim_state = "Idle"
		agent.controller.dir = Vector2.ZERO
		return true
	elif agent.controller.moving and is_instance_valid(wood):
		print("Moving to the wood...")
		if agent.controller.context_map.pers_space.has_overlapping_bodies():
			# WARN - Weird ass bug. 'Monitorable' has to be turned ON for
			# StaticBodies to be seen. So weird, and I think I removed some b4
			print("I think I am stuck!! ", agent.controller.dir)
			var y = agent.controller.dir.y
			var x = agent.controller.dir.x
			if y > 0.8 and y <= 1 or y < -0.8 and y >= -1 and agent.gbl_timer.is_stopped():
				agent.gbl_timer.start(1.2)
				if randi_range(0, 1): y = y * -1
				agent.controller.dir = Vector2(y, x)
			elif x > 0.8 and x <= 1 or x < -0.8 and x >= -1 and agent.gbl_timer.is_stopped():
				# TODO - x is more problematic, bounces up and down frequently... Polish
				agent.gbl_timer.start(1.2)
				if randi_range(0, 1): x = x * -1
				agent.controller.dir = Vector2(y, x)
			elif agent.gbl_timer.is_stopped():
				agent.controller.dir = agent.controller.context_map.chosen_dir
		else:
			agent.controller.dir = agent.global_position.direction_to(wood.global_position)
			print("All fine so far... ", agent.controller.dir)
	elif not is_instance_valid(wood):
		## WARN - Check if there is wood on the ground, same for trees maybe, 
		## in case they get removed during this perform, or it will crash
		wood = agent.get_closest_element("Wood", agent)
		agent.controller.dir = agent.global_position.direction_to(wood.global_position)
		agent.controller.anim_state = "Move"
		agent.controller.entity_move.emit()
	
	return false
