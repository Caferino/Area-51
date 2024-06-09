class_name FollowState extends DogStateStats

# TODO - Clean all this FSM code. Watch out for the "get_parent()".
var distance_to_keep = 25
var is_moving = true

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	move_speed = 100.0


func State_Process(_delta):
	var direction = player.global_position - enemy.global_position
	
	if direction.length() > distance_to_keep and player.global_position != get_parent().target_last_position or direction.length() > get_parent().distance_tolerance:
		is_moving = true
		get_parent().timer.stop()
		distance_to_keep = 25
		enemy.velocity = direction.normalized() * move_speed
	elif is_moving:
		is_moving = false
		distance_to_keep = 50
		enemy.velocity = Vector2()
		get_parent().target_last_position = player.global_position
		get_parent().timer.start(6)
	
	if direction.length() > 400:
		Transitioned.emit(self, "Idle")


func _on_timer_timeout() -> void:
	# print("wtf")
	Transitioned.emit(self, "Idle")
