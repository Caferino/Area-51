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
	# TODO - ADAPT THIS, might not need this, judging my game's context.
	# It might be something completely different, think Rimworld, which
	# costs and priorities might be more straightforward or loyal to time.
	#if agent._states.has("global_position"):
		#var closest_tree = agent.get_closest_element("tree", blackboard)
		#return int(closest_tree.position.distnce_to(blackboard.position) / 7)
	return 3


func get_preconditions() -> Dictionary:
	return {}


func get_effects() -> Dictionary:
	return {
		"dropped_wood" : true
	}


func perform(agent, _delta) -> bool:
	print("Performing chop_tree!")
	if agent.controller.moving and tree:
		print("Moving...")
		if agent.controller.interactor_area.overlaps_area(tree):
			print("Performing a sharp cut!!!!")
			near_tree = true   ## WARN - Do not forget to set it to null after chop
			agent.controller.dir = Vector2.ZERO
			agent.controller.anim_state = "Idle"
			agent.controller.moving = false  ## Without it this block runs twice, Moonwalk's Paradox
		elif agent.controller.context_map.pers_space.overlaps_area(tree) or agent.controller.context_map.pers_space.has_overlapping_bodies():
			print("I think I am stuck!! ", agent.controller.dir)
			# NOTE - The randomness helps with getting stuck looping vertically or horizontally
			# I tried to make it more granular, but you either choose x or y, positive or negative,
			# it's very difficult to make it work that smart with this. Maybe need a more expensive
			# and complex system for that (know if moving left or right is better than down or up).
			# So far this works well and it's cheap as hell, and only looks bad when the player 
			# has the goal to make it look bad, and even so, it's like 70% fine. Good enough.
			agent.controller.dir = agent.controller.context_map.chosen_dir + Vector2(randf_range(-1, 1), randf_range(-1, 1))
		else:
			agent.controller.dir = agent.global_position.direction_to(tree.global_position)
	elif near_tree:
		print("Got a tree in front of me, boss!")
		## WARNING TODO - Right now, the NPC can be pushed away from the tree
		## while it chops, but it won't stop cause tree holds the Area2D now.
		## Maybe someday make it so it checks if it's still overlapping, return.
		## Might make it a little more expensive, but they'd be more intelligent
		## and might be necessary if they get pushed away by something strong
		## Reuse the for a in areas loop above maybe
		if agent.get_elements("Wood").size() > 20:
			return true
		elif not agent.controller.interactor_area.overlaps_area(tree):
			near_tree = false
			tree = null
		elif agent.g_timer.is_stopped() and tree.get_parent().interactable.state:
			agent.g_timer.start(2.5)
			print("Chopping!")
			tree.get_parent().interact("hatchet")
	elif not tree:
		tree = agent.get_closest_element("Tree", agent)
		agent.controller.dir = agent.global_position.direction_to(tree.global_position)
		agent.controller.anim_state = "Move"
		agent.controller.entity_move.emit()
	
	return false
