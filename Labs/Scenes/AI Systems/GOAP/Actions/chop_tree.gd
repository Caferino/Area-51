class_name ChopTreeAction extends GoapAction

## WARNING - This one will get tricky at the moment of moving the entity to
## the tree, I am foreseeing it: how to position the entity so its interactor
## is overlapping the tree's cutting interact area? So it doesn't get stuck.
## I thought about using a wide circle interactor instead of the tiny ass rectangle
## the main player has, but, I'd like entities to be as close to the player,
## to mimick their movements more precisely. I will have to cheat, but maybe
## it's not merited here. If I solve this positioning problem, I could use this tech
## for spell casts, or other complex stuff. Some games make it so the NPC
## reaches the area around the tree and gets teleported to a valid position
## already set by the developers. Maybe I can add "hint dots" "hint positions"
## the entity will try to stand on and face towards the given direction. A big tree
## could have 4 of these dots, north, east, west, south... maybe more, as it's big...

## How to move the entity towards a tree and stop properly, not walk endlessly towards
## its center?

var tree      : Area2D = null
var near_tree : bool   = false

func get_class_name(): return "ChopTreeAction"

func is_valid(agent) -> bool:
	return agent.get_elements("Tree").size() > 0


func get_cost(_agent) -> int:
	return 1


func get_preconditions() -> Dictionary:
	return {}


func get_effects() -> Dictionary:
	return {
		"chopped_wood" : true
	}


func perform(agent, _delta) -> bool:
	print("Performing chop_tree!")
	if agent.get_elements("Wood").size() + agent.controller.entity.inventory.items["Logs"] >= agent.states["need_wood"]:
		print("CHOP_TREE ACTION SHOULD BE FINISHED NOW!")
		agent.controller.dir = Vector2.ZERO
		agent.controller.anim_state = "Idle"
		agent.controller.moving = false  ## Without it this block runs twice, Moonwalk's Paradox
		return true
	elif agent.controller.moving and tree:
		print("Moving to the tree...")
		if agent.controller.interactor_area.overlaps_area(tree):
			print("Reached the tree!")
			near_tree = true   ## WARN - Do not forget to set it to null after chop
			agent.controller.dir = Vector2.ZERO
			agent.controller.anim_state = "Idle"
			agent.controller.moving = false  ## Without it this block runs twice, Moonwalk's Paradox
		## TODO - Reuse this elif for wandering, chasing, etc. It works well. 
		elif agent.controller.context_map.pers_space.overlaps_area(tree) or agent.controller.context_map.pers_space.has_overlapping_bodies():
			print("I think I am stuck!!")
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
			agent.controller.dir = agent.global_position.direction_to(tree.global_position)
	elif near_tree:
		print("Got the tree in front of me!")
		if not agent.controller.interactor_area.overlaps_area(tree):
			print("Lost the tree! Did you push me away?")
			near_tree = false
			tree = null
		elif agent.gbl_timer.is_stopped() and tree.get_parent().interactable.state:
			print("Chopping!")
			agent.gbl_timer.start(2.5)
			tree.get_parent().interact("hatchet")
	elif not tree:
		tree = agent.get_closest_element("Tree", agent)
		agent.controller.dir = agent.global_position.direction_to(tree.global_position)
		agent.controller.anim_state = "Move"
		agent.controller.entity_move.emit()
	
	return false
