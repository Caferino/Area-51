class_name BuildFirepitAction extends GoapAction

# TODO - CHANGE IT, no idea where did this one come from...
const Firepit = preload("res://Labs/Scenes/Interactables/firepit/firepit.tscn")

var spot : Vector2 = Vector2.ZERO
var thread : Thread = Thread.new()
var valid_spot : bool = false  ## Found spot

func get_class_name(): return "BuildFirepitAction"

func _init() -> void:
	# Because I'm a big man with big pants:
	#Thread.set_thread_safety_checks_enabled(false)
	SignalManager.search_done.connect(_search_done)


#func _exit_tree() -> void:
	#Thread.set_thread_safety_checks_enabled(true)

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
	print("Performing build_firepit!")
	if valid_spot:
		print("Building the firepit!")
		# The second parameter is fucking disgusting, look at that shit, oh fuck, it's below me
		ItemManager.place_structure(spot, agent.controller.get_parent().get_parent().get_parent())
		valid_spot = false
		#agent.controller.entity.inventory.items["Logs"] -= agent.states["need_wood"]
		return true
	elif not thread.is_alive() and not valid_spot:
		print("Searching for a valid spot...")
		var area = agent.detection_area.find_child("CollisionShape")
		var area_size_x = area.get_shape().size.x / 2
		var area_size_y = area.get_shape().size.y / 2
		var area_x = area.global_position.x
		var area_y = area.global_position.y
		
		thread.start(_search_spot.bind(agent, area_size_x, area_size_y, area_x, area_y))
	return false


func _search_spot(agent, area_size_x, area_size_y, area_x, area_y) -> bool:
	print("Searching... = ", area_size_x, " ", area_size_y, " ", area_x, " ", area_y)
	ItemManager.prepare_structure("firepit", agent.controller.get_parent().get_parent().get_parent())
	for i in 7:  # 7 attempts, O(7)
		var rand_x = randf_range(area_x - area_size_x, area_x + area_size_x)
		var rand_y = randf_range(area_y - area_size_y, area_y + area_size_y)
		spot = Vector2(rand_x, rand_y)
		print("Spot coordinates = ", spot)
		ItemManager.verify_structure_area(spot)
	call_deferred("_search_done_dum")
	return false


func _search_done_dum():
	var trash = thread.wait_to_finish()


func _search_done(target):
	#if not curr_area.has_overlapping_bodies(): # FIXME - Not working well
		#if not valid_spot:
			#valid_spot = true
			#spot = global_position
		#print("SUCCESS !!! ############################## ", curr_area.global_position)
		##return true
	#else:
		#print("OVERLAP !!! ============================")
	if not valid_spot:
		valid_spot = true
		spot = target
	#valid_spot = thread.wait_to_finish()
	print("Spot value returned! = ", valid_spot)
