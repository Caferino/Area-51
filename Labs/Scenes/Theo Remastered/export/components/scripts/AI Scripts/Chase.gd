extends ActionLeaf

func tick(actor, _blackboard):
	# The DelayDecorator fixes a janky movement error when switching from
	# "Entity Too Close" to "Chasing!" a lot too quickly.
	# It also simulates the short "surprise" moment of shock a person has before acting.
	## get_parent().wait_time = 0   ## WARNING Enable this if you add a new "return SUCCESS"
	var current_target_distance = 0.00
	if actor.current_target:
		current_target_distance = actor.global_position.distance_to(actor.current_target.global_position)
	else:
		print("He got away x2!!!")
		#actor.dir = Vector2.ZERO  # NOTE - This makes him not stop walking, is bad though
		actor.anim_state = "Idle"
		actor.sprinting = false
		return FAILURE
	
	if current_target_distance >= actor.enemy_distance_tolerance + 50:
		print("Sprinting!!!")
		actor.dir = actor.global_position.direction_to(actor.current_target.global_position)
		actor.anim_state = "Run"
		actor.sprinting = true
		return RUNNING
	elif current_target_distance >= actor.enemy_distance_tolerance:
		print("Chasing!!")
		actor.dir = actor.global_position.direction_to(actor.current_target.global_position)
		actor.anim_state = "Move"
		actor.sprinting = false
		return RUNNING
	elif current_target_distance > 0:
		print("Too close!")
		actor.dir = Vector2.ZERO
		actor.anim_state = "Idle"
		actor.sprinting = false
		## TODO - Rotate him here somehow without moving. No method for that yet
		return SUCCESS
	#else:  ## DEPRECATED
		#print("He got away!!")
		#actor.anim_state = "Idle"
		#actor.sprinting = false
		#actor.dir = Vector2.ZERO
		#return FAILURE
