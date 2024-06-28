class_name BatAIControllerComponent extends AIEntityController
## An entity "bat" being controlled by an [color=violet]AI.

## TODO - The logic should be as follow:
# When Idle, Wandering or Fleeing, the bat is NOT busy
# When Chasing or Attacking, the bat IS busy
# When busy, suck energy. When not busy, recharge it.

# When fleeing, it should probably consider if the enemy is nearby
# to know when to stop and be idle/wander, not flee forever

# WARN - Combining SUM and MULT aggregations in a way that it goes beyond 1.0
# is useful to keep that action on top as long as you need, before it returns back
# below under 1.0

## TODO - Energy can be used to balance this mob in combat.
## Once its energy reaches 0, it can start moving slow or need to flee...
## What should recharge it? When it is Idle? Fleeing? Wandering too?
## Should energy be consumed only while Chasing and Attacking?
## TODO Should the energy variable be used only during combat?
## When should it recharge, when decrease?


func _ready():
	context_map.chosen_dir_updated.connect(_on_chosen_dir_updated)


func _process(delta: float):
	_handle_environment()
	_handle_energy(delta)
	call(current_action)


## Not sure if this will stay or fuse
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
		if moving:
			if entity.heart.energy - 0.05 < 0.0: 
				entity.heart.energy = 0.0
			else:
				entity.heart.energy -= 0.05
		else:
			if entity.heart.energy + 0.05 > 1.0:
				entity.heart.energy = 1.0
			else:
				entity.heart.energy += 0.05
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


func _get_wander_time():
	return $WanderTime.time_left


func _get_energy():
	return entity.heart.energy


func _get_health():
	return entity.heart.health


func _on_chosen_dir_updated():
	dir = context_map.chosen_dir


## AI component that judges the situation to choose the best direction to go to.
func situational_awareness():
	if chasing:
		return self.global_position.direction_to(current_target.global_position)
	else:
		return context_map.chosen_dir


# ===== ===== ===== UTILITY AI SYSTEM ===== ===== ===== #
func _on_bat_utility_ai_agent_top_score_action_changed(top_action_id: Variant) -> void:
	call(current_action + "_Exit")
	current_action = top_action_id
	call(top_action_id + "_Enter")


# ===== ===== Idle ===== ===== #
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


# ===== ===== Wander ===== ===== #
func Wander_Enter():
	print("Wander Enter!")
	wandering = true
	moving = true


func Wander():
	print("Wandering!")
	if $WanderTime.time_left == 0:
		dir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	else:
		$WanderTime.start(randf_range(0, 1))
	# WARN - These will pile up
	#await get_tree().create_timer(randf_range(0.15, 0.3)).timeout  # Lower for erratic speed


func Wander_Exit():
	print("Wander Exit!")
	wandering = false
	moving = false


# ===== ===== Chase ===== ===== #
func Chase_Enter():
	print("Chase Enter!")
	chasing = true
	moving = true


func Chase():
	print("Chasing!")
	
	dir = self.global_position.direction_to(current_target.global_position)


func Chase_Exit():
	print("Chase Exit!")
	chasing = false
	moving = false


# ===== ===== Attack ===== ===== #
func Attack_Enter():
	print("Attack Enter!")
	attacking = true


func Attack():
	print("Attacking!")


func Attack_Exit():
	print("Attack Exit!")
	attacking = false


# ===== ===== Flee ===== ===== #
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
