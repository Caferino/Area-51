class_name ChopTreeAction extends GoapAction

var tree      : Area2D = null   ## The current targeted tree.
var near_tree : bool   = false  ## Determines whether the entity is properly positioned.

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


## The chop_tree's perform: It positions itself in front of the closest tree and chops it down.
## [br][br]
## If no tree has been detected, it searches for the closest one within its detection_area.
## It then moves toward it and places itself properly in front of it to avoid getting stuck on corners.
## It interacts with the tree (chop it down) until there's enough wood on the ground.
func perform(agent, _delta) -> bool:
	if agent.get_elements("Wood").size() + agent.controller.entity.inventory.items["Logs"] >= agent.states["need_wood"]:
		agent.controller.dir = Vector2.ZERO
		agent.controller.anim_state = "Idle"
		agent.controller.moving = false  ## Without it this block runs twice, Moonwalk's Paradox
		return true
	elif agent.controller.moving and tree:
		if agent.controller.interactor_area.overlaps_area(tree):
			near_tree = true   ## WARN - Do not forget to set it to null after chop
			agent.controller.dir = Vector2.ZERO
			agent.controller.anim_state = "Idle"
			agent.controller.moving = false  ## Without it this block runs twice, Moonwalk's Paradox
		## TODO - Reuse this elif for wandering, chasing, etc. It works well. 
		elif agent.controller.context_map.pers_space.overlaps_area(tree) or agent.controller.context_map.pers_space.has_overlapping_bodies():
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
		if not agent.controller.interactor_area.overlaps_area(tree):
			near_tree = false
			tree = null
		elif agent.gbl_timer.is_stopped() and tree.get_parent().interactable.state:
			agent.gbl_timer.start(2.5)
			tree.get_parent().interact("hatchet")
	elif not tree:
		tree = agent.get_closest_element("Tree", agent)
		agent.controller.dir = agent.global_position.direction_to(tree.global_position)
		agent.controller.anim_state = "Move"
		agent.controller.entity_move.emit()
	
	return false
