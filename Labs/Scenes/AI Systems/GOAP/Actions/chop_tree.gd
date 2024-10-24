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
var chopping  : bool   = false
var near_tree : bool   = false
var prev_dis  : float  = 10000.0      ## To know if the entity is stuck. 

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
		if agent.controller.interactor_area.has_overlapping_areas():
			print("Overlapping areas... true!")
			var areas = agent.controller.interactor_area.get_overlapping_areas()
			for a in areas:
				print("a in areas = ", a)
				if a.is_in_group("Tree"):
					print("Performing a very sharp cut!!!!")
					near_tree = true   ## WARN - Do not forget to set it to null after chop
					agent.controller.dir = Vector2.ZERO
					agent.controller.anim_state = "Idle"
					agent.controller.moving = false  ## Without it this block runs twice, Moonwalk's Paradox
		else:
			agent.controller.dir = agent.global_position.direction_to(tree.global_position)
			
			## Instead of all this I could use the ContextMap's AwareZone
			## Might need to add it to HumanoidAIComponent and do a
			## context_map.aware_zone_area.overlaps_area(tree)  # tree is already an Area2D right?
			var curr_dis = agent.global_position.distance_to(tree.global_position)
			if agent.controller.context_map.pers_space.overlaps_area(tree):
				print("I think I am stuck!!")
				agent.controller.dir = agent.controller.context_map.chosen_dir
			prev_dis = curr_dis
	elif near_tree:
		print("Got a tree in front of me, boss!")
	elif not chopping:
		tree = agent.get_closest_element("Tree", agent)
		agent.controller.dir = agent.global_position.direction_to(tree.global_position)
		agent.controller.anim_state = "Move"
		agent.controller.entity_move.emit()
	## 1. Give dir to the AI Controller
	## 2. In an if/else, if it's moving and hasn't gotten stuck, keep moving until
	## the interactor overlaps the tree's interation area.
	## -- 2.1 To know if it has gotten stuck, while it's moving, save the previous
	## position the NPC was on the previous frame. If it's stuck, such difference
	## shall be near zero. Problem is I might need to measure this, might be
	## some really small numbers, decimals, < 0.0 
	## 3. Once the interactor overlaps, quickly proceed to chop the tree.
	## Might use or need a cooldown timer for this short animation or something.
	## 4. Once he drops n amount of logs, he should move on to collect_wood.
	## This probably means this entire action can be skipped, shortened, or
	## interrupted if there's already wood on the ground, dropped by someone else,
	## etc, if is_valid is checked every tick that is. This can be problematic too,
	## if multiple lumberjacks are chopping a tree, constantly interrupting eachother.
	## Maybe the priority, cost or something for collect_wood should be low, or
	## work on that much later, on a way to synchronize multiple NPCs workers or enemies
	## to make them feel smart and powerful. An invisible leader/commander.
	
	#if _closest_tree:
		### NOTE - This condition is doing a good job at stopping the NPC around the tree...
		### Expand on it, check if overlapping_areas...
		#if _closest_tree.position.distance_to(agent.position) < 10:
			#if agent.chop_tree(_closest_tree):
				#agent.set_state("has_wood", true)
				#return true
			#return false
		#else:
			## TODO - Adapt, send dir to entity's controller
			#agent.move_to(agent.position.direction_to(_closest_tree.position), delta)
	return false
