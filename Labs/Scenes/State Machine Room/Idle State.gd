class_name IdleState extends DogStateStats


var move_direction : Vector2
var wander_time : float
var moving = true


func randomize_wander():
	moving = false
	move_speed = 0
	await get_tree().create_timer(randf_range(2, 5)).timeout 
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(3, 6)
	move_speed = 25.0
	moving = true


func Enter():
	player = get_tree().get_first_node_in_group("Player")
	move_speed = 50.0
	randomize_wander()


func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	elif moving:
		randomize_wander()


func State_Process(_delta):
	if enemy:
		enemy.velocity = move_direction * move_speed
	
	var direction = player.global_position - enemy.global_position
	
	# print(direction.length())
	
	if direction.length() < 200 and player.global_position != get_parent().target_last_position or direction.length() > get_parent().distance_tolerance and player.global_position == get_parent().target_last_position:
		Transitioned.emit(self, "Follow")
