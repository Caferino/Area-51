class_name BatAIControllerComponent extends AIEntityController
## An entity "bat" being controlled by an [color=violet]AI.


func _ready():
	context_map.chosen_dir_updated.connect(_on_chosen_dir_updated)


func _process(delta: float):
	_handle_energy(delta)
	call(current_action)


func _handle_energy(delta: float):
	time_accumulator += delta
	if time_accumulator >= 1.0:
		time_accumulator -= 1.0
		var energy_amount = randf_range(0.01, 0.06)
		if moving:
			if entity.heart.energy - energy_amount < 0.0:
				stun(3)
				entity.heart.energy = 0.0
			else:
				entity.heart.energy -= energy_amount
		else:
			if entity.heart.energy + energy_amount * 2 > 1.0:
				entity.heart.energy = 1.0
			else:
				entity.heart.energy += energy_amount * 2
		#print("Energy: ", entity.heart.energy, " and moving: ", moving)  # DEBUG


func _on_echolocation_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Noise"):
		current_target = area
		target_location = current_target.global_position
		target_distance = entity.global_position.distance_to(target_location)
		enemy_nearby = true


func _on_echolocation_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("Noise"):
		target_location = current_target.global_position
		#current_target = null ## TODO - What if lost when > distance_treshold
		enemy_nearby = false


func _on_claws_area_area_entered(_area: Area2D) -> void:
	if $AttackCooldown.time_left == 0:
		$AttackCooldown.start(1)
		if randf() <= 0.25:
			# TODO - Hurt/deal damage to the entity
			print("CaveBat bites the player!")


## TODO - Create an animation (sweat drops, flash blue) as a clue
func stun(time: float) -> void:
	stunned = true
	$ClawsArea.monitoring = false
	await get_tree().create_timer(time).timeout
	$ClawsArea.monitoring = true
	stunned = false


## Receives the ContextMap's chosen direction.
func _on_chosen_dir_updated():
	dir = context_map.chosen_dir


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
	dir = Vector2.ZERO


func Idle_Exit():
	print("Idle Exit!")
	idle = false


## ===== ===== Wander ===== ===== ##
func Wander_Enter():
	print("Wander Enter!")
	$WanderTime.start(randf_range(1, 3))
	wandering = true


func Wander():
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
	in_combat = true
	chasing = true
	moving = true


func Chase():
	if current_target:
		target_location = current_target.global_position
		target_distance = entity.global_position.distance_to(target_location)
		if target_distance > 30:
			offset = randf_range(-0.1, 0.1)
			dir = (entity.global_position.direction_to(target_location) + Vector2(offset, offset)).normalized()


func Chase_Exit():
	print("Chase Exit!")
	in_combat = false
	chasing = false
	moving = false


## ===== ===== Attack ===== ===== ##  POSSIBLY DEPRECATED
#func Attack_Enter():
	#print("Attack Enter!")
	#in_combat = true
	#attacking = true
	#moving = true
#
#
#func Attack():
	#print("Attacking! ")
	#if current_target:
		#target_location = current_target.global_position
		#target_distance = entity.global_position.distance_to(target_location)
#
#
#func Attack_Exit():
	#print("Attack Exit!")
	#in_combat = false
	#attacking = false
	#moving = false


## ===== ===== Flee ===== ===== ##
func Flee_Enter():
	print("Flee Enter!")
	offset = randf_range(-0.7, 0.7)
	enemy_too_close = true
	in_combat = false
	fleeing = true
	moving = true


func Flee():
	target_distance = entity.global_position.distance_to(target_location)
	if current_target:
		target_location = current_target.global_position
		if entity.global_position.distance_to(target_location) > 500:  # TODO - Move somewhere else
			print("Lost target!")
			current_target = null
	
	dir = -entity.global_position.direction_to(target_location) + Vector2(offset, offset)
	# NOTE - Not normalizing dir here gives a cool "flinch", "adrenaline rush sprint" effect 
	# randomly sometimes whenever x or y go beyond 1.0, unlike in Chase()


func Flee_Exit():
	print("Flee Exit!")
	enemy_too_close = false
	fleeing = false
	moving = false
