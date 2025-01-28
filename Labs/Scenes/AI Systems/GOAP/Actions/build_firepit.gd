class_name BuildFirepitAction extends GoapAction

# TODO - CHANGE IT, no idea where did this one come from...
const Firepit = preload("res://Labs/Scenes/Interactables/Firepit/firepit.tscn")

var try  : bool             = false         ## Also called "try_again", used for the placing attempts.
var spot : Vector2          = Vector2.ZERO  ## The spot at where to try to place the structure.
var area : CollisionShape2D = null          ## Variable for the structure's area used in collisions.
#var attempts : int = 10  ## TODO - Maybe as a safety measure in the future.

func get_class_name(): return "BuildFirepitAction"

func is_valid(_agent: HumanAiGoap) -> bool:
	return true


func get_cost(_agent: HumanAiGoap) -> int:
	return 1


func get_preconditions() -> Dictionary:
	return {
		"has_wood" : true
	}


func get_effects() -> Dictionary:
	return {
		"has_firepit" : true
	}


## The build_firepit's perform: It attempts to place the structure in a valid spot.
## [br][br]
## valid_spot and try should start as false, so the perform can first prepare the
## firepit scene in ItemManager's memory (might change to StructureManager), and
## then use its StructureArea to see if it overlaps with anything it shouldn't.
## It checks that and tries again until it is in a valid spot.
func perform(agent: HumanAiGoap, _delta: float) -> bool:
	if ItemManager.valid_spot:
		# FIXME - The second parameter is disgusting, look at that shit! Fuck, it's below me now!
		ItemManager.place_structure(spot, agent.controller.get_parent().get_parent().get_parent())
		try = false
		## TODO - Make a method in inventory to remove items, and safe-check >= 0
		agent.controller.entity.inventory.items["Logs"] -= agent.states["need_wood"]
		return true
	elif try:
		spot = _random_position()
		ItemManager.move_structure_area(spot)
	else:
		try = true
		ItemManager.prepare_structure("firepit", agent.controller.get_parent().get_parent().get_parent())
		if not area:
			area = agent.detection_area.find_child("CollisionShape")
		spot = _random_position()
		ItemManager.move_structure_area(spot)
	return false


## Returns a random Vector2 global_position within the entity's detection_area. 
func _random_position() -> Vector2:
	var area_size_x = area.get_shape().size.x / 2
	var area_size_y = area.get_shape().size.y / 2
	var area_x = area.global_position.x
	var area_y = area.global_position.y
	var rand_x = randf_range(area_x - area_size_x, area_x + area_size_x)
	var rand_y = randf_range(area_y - area_size_y, area_y + area_size_y)
	return Vector2(rand_x, rand_y)
