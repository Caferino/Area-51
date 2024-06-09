extends ActionLeaf

func tick(actor, _blackboard):
	var current_target_distance = 0.00
	if actor.current_target:
		current_target_distance = actor.global_position.distance_to(actor.current_target.global_position)
	else:
		print("He got away x2!!!")
		actor.is_sprinting = false
		return FAILURE
	
	if current_target_distance >= actor.enemy_distance_tolerance + 50:
		print("Sprinting!!!")
		actor.is_sprinting = true
		actor.dir = actor.global_position.direction_to(actor.current_target.global_position)
		return RUNNING
	elif current_target_distance >= actor.enemy_distance_tolerance:
		print("Chasing!!")
		actor.is_sprinting = false
		actor.dir = actor.global_position.direction_to(actor.current_target.global_position)
		return RUNNING
	elif current_target_distance > 0:
		print("Too close!")
		actor.is_sprinting = false
		## TODO - Rotate him here somehow without moving. No method for that yet
		actor.dir = Vector2.ZERO
		return RUNNING
	else:
		print("He got away!!")
		actor.is_sprinting = false
		actor.dir = Vector2.ZERO
		return FAILURE
