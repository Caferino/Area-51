extends ActionLeaf

## wander_time for move duration, wait_time for "turning-frequency"
var wander_time = 0
var wait_time   = randf_range(2, 4)  # Getting rid of the DelayerDecorator makes this script run 
# every frame, but I can interrupt the wandering right at the moment he sees me, unlike before...


func _physics_process(delta):
	if wander_time > 0: wander_time -= delta
	if wait_time > 0: wait_time -= delta


func tick(actor, _blackboard):
	if actor.is_enemy_nearby:
		print("Enemy nearby")
		wander_time = 0
		wait_time = 0
		return FAILURE
	else:
		if actor.dir != Vector2.ZERO and wander_time <= 0:
			print("Stop Wandering")
			actor.anim_state = "Idle"
			actor.dir = Vector2.ZERO
			wait_time = randf_range(2, 5)
			return SUCCESS
		elif wait_time <= 0:
			print("Wandering")
			actor.anim_state = "Move"
			actor.dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			if wander_time <= 0: wander_time = randf_range(2, 8)
			if wait_time <= 0: wait_time = randf_range(2, 5)
			return SUCCESS
	return SUCCESS
