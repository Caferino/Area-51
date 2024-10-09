extends Node
## WARN - IS DONE BY THE NPC, HOLD IT IN AN INTERNAL MEMORY OR SOMETHING
var states : Dictionary = {}


func get_state(state_name, default = null):
	return states.get(state_name, default)


func set_state(state_name, value):
	states[state_name] = value


func clear_state():
	states = {}


func get_elements(group_name):
	return self.get_tree().get_nodes_in_group(group_name)


## WARNING - MIGHT NEED TO CREATE THIS WITH MY OWN LOGIC OR NEEDS
## NOTE - THIS SEEKS CLOSE ITEMS LIKE TREES, FOOD, ETC, BUT, MAYBE THAT STUFF
## IS DONE BY THE NPC, HOLD IT IN AN INTERNAL MEMORY OR SOMETHING
func get_closest_element(group_name, reference):
	var elements = get_elements(group_name)
	var closest_element
	var closest_distance = 1000000000
	
	for element in elements:
		var distance = reference.position.distance_to(element.position)
		if distance < closest_distance:
			closest_distance = distance
			closest_element = element
	
	return closest_element
