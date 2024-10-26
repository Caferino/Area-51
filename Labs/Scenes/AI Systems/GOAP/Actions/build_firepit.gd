class_name BuildFirepitAction extends GoapAction

# TODO - CHANGE IT, no idea where did this one come from...
const Firepit = preload("res://Labs/Scenes/Interactables/firepit/firepit.tscn")

var area : CollisionShape2D = null
var spot : Vector2 = Vector2.ZERO
var try_place : bool = false

func get_class_name(): return "BuildFirepitAction"

func is_valid(_agent) -> bool:
	return true


func get_cost(_agent) -> int:
	return 1


func get_preconditions() -> Dictionary:
	return {
		"has_wood" : true
	}


func get_effects() -> Dictionary:
	return {
		"has_firepit" : true
	}


func perform(agent, _delta) -> bool:
	print("Performing build_firepit!")  # DEBUG
	if ItemManager.valid_spot:
		print("Building the firepit! -------------")  # DEBUG
		# FIXME - The second parameter is disgusting, look at that shit! Fuck, it's below me now!
		ItemManager.place_structure(spot, agent.controller.get_parent().get_parent().get_parent())
		try_place = false
		#agent.controller.entity.inventory.items["Logs"] -= agent.states["need_wood"]
		return true
	elif try_place:
		print("Trying again! -----------")  # DEBUG
		spot = _random_position()
		ItemManager.move_structure_area(spot)
	else:
		print("Preparing firepit! ---------- ")  # DEBUG
		try_place = true
		ItemManager.prepare_structure("firepit", agent.controller.get_parent().get_parent().get_parent())
		if not area:
			area = agent.detection_area.find_child("CollisionShape")
		spot = _random_position()
		ItemManager.move_structure_area(spot)
	return false


func _random_position() -> Vector2:
	var area_size_x = area.get_shape().size.x / 2
	var area_size_y = area.get_shape().size.y / 2
	var area_x = area.global_position.x
	var area_y = area.global_position.y
	var rand_x = randf_range(area_x - area_size_x, area_x + area_size_x)
	var rand_y = randf_range(area_y - area_size_y, area_y + area_size_y)
	return Vector2(rand_x, rand_y)
