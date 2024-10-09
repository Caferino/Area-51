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

func get_class_name(): return "ChopTreeAction"

func is_valid() -> bool:
	return true
	#return WorldState.get_elements("tree").size() > 0


func get_cost(blackboard) -> int:
	if blackboard.has("global_position"):
		# TODO - ADAPT THIS
		return 3
		#var closest_tree = WorldState.get_closest_element("tree", blackboard)
		#return int(closest_tree.position.distnce_to(blackboard.position) / 7)
	return 3


func get_preconditions() -> Dictionary:
	return {}


func get_effects() -> Dictionary:
	return {
		"dropped_wood" : true
	}


func perform(actor, delta) -> bool:
	#var _closest_tree = WorldState.get_closest_element("Tree", actor)
	
	#if _closest_tree:
		### NOTE - This condition is doing a good job at stopping the NPC around the tree...
		### Expand on it, check if overlapping_areas...
		#if _closest_tree.position.distance_to(actor.position) < 10:
			#if actor.chop_tree(_closest_tree):
				#WorldState.set_state("has_wood", true)
				#return true
			#return false
		#else:
			## TODO - Adapt, send dir to entity's controller
			#actor.move_to(actor.position.direction_to(_closest_tree.position), delta)
	return false
