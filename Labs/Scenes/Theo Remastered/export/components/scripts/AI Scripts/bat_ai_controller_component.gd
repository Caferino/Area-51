class_name BatAIControllerComponent extends AIEntityController
## An entity "bat" being controlled by an [color=violet]AI.


func _ready():
	context_map.chosen_dir_updated.connect(_on_chosen_dir_updated)


func _process(delta: float):
	_handle_environment()
	_handle_energy(delta)
	call(current_action)


## WARN - Not sure if this will stay or fuse
## This could loop in the Chase state maybe DEPRECATED
func _handle_environment():
	if current_target:
		if entity.global_position.distance_to(current_target.global_position) < 30:
			enemy_too_close = true
		else:
			enemy_too_close = false


func _handle_energy(delta: float):
	time_accumulator += delta
	if time_accumulator >= 1.0:
		time_accumulator -= 1.0
		var energy_amount = randf_range(0.01, 0.06)
		if moving:
			if entity.heart.energy - energy_amount < 0.0: 
				entity.heart.energy = 0.0
			else:
				entity.heart.energy -= energy_amount
		else:
			if entity.heart.energy + energy_amount > 1.0:
				entity.heart.energy = 1.0
			else:
				entity.heart.energy += energy_amount
	print("Energy: ", entity.heart.energy, " and moving: ", moving)  # DEBUG


func _on_echolocation_area_area_entered(area: Area2D) -> void:
	print("Area entered")
	if area.is_in_group("Noise"):
		enemy_nearby = true
		current_target = area


func _on_echolocation_area_area_exited(area: Area2D) -> void:
	print("Area exited")
	if area.is_in_group("Noise"):
		chasing = false
		enemy_nearby = false
		current_target = null


## AI component that judges the situation to choose the best direction to go to.
func situational_awareness():
	if chasing:
		return self.global_position.direction_to(current_target.global_position)
	else:
		return context_map.chosen_dir


## Receives the ContextMap's chosen direction.
func _on_chosen_dir_updated():
	dir = context_map.chosen_dir


### Utility agent access method.
#func _get_wander_time():
	#return $WanderTime.time_left


## Utility agent access method.
func _get_energy():
	return entity.heart.energy


## Utility agent access method.
func _get_health():
	return entity.heart.health


## ===== ===== ===== UTILITY AI SYSTEM ===== ===== ===== ##
func _on_bat_utility_ai_agent_top_score_action_changed(top_action_id: Variant) -> void:
	call(current_action + "_Exit")
	current_action = top_action_id
	call(top_action_id + "_Enter")


## ===== ===== Idle ===== ===== ##
func Idle_Enter():
	print("Idle Enter!")
	idle = true
	moving = false


func Idle():
	print("Idle!")
	
	dir = Vector2.ZERO
	#if randi_range(1, 10) <= 2:  # 20% chance to stop moving/wander. Might need a better way using energy
		#await get_tree().create_timer(randf_range(0.5, 1)).timeout


func Idle_Exit():
	print("Idle Exit!")
	idle = false


## ===== ===== Wander ===== ===== ##
func Wander_Enter():
	print("Wander Enter!")
	$WanderTime.start(randf_range(1, 6))
	wandering = true


func Wander():
	print("Wandering!")
	if $WanderTime.time_left == 0:
		$WanderTime.start(randf_range(0.1, 0.5))
		dir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
		moving = true


func Wander_Exit():
	print("Wander Exit!")
	wandering = false
	moving = false


## ===== ===== Chase ===== ===== ##
func Chase_Enter():
	print("Chase Enter!")
	chasing = true
	moving = true


func Chase():
	print("Chasing!")
	
	## NOTE - CHECK OUT handle_environment() ABOVE
	
	dir = self.global_position.direction_to(current_target.global_position)


func Chase_Exit():
	print("Chase Exit!")
	chasing = false
	moving = false


## ===== ===== Attack ===== ===== ##
func Attack_Enter():
	print("Attack Enter!")
	attacking = true


func Attack():
	print("Attacking!")


func Attack_Exit():
	print("Attack Exit!")
	attacking = false


## ===== ===== Flee ===== ===== ##
func Flee_Enter():
	print("Flee Enter!")
	fleeing = true
	moving = true


func Flee():
	print("Fleeing!")


func Flee_Exit():
	print("Flee Exit!")
	fleeing = false
	moving = false
