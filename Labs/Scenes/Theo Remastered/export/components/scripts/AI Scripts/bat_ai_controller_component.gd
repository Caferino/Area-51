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


func _get_energy():
	return entity.heart.energy


func _get_health():
	return entity.heart.health


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


# ===== ===== ===== UTILITY AI SYSTEM ===== ===== ===== #
func _on_bat_utility_ai_agent_top_score_action_changed(top_action_id: Variant) -> void:
	call(top_action_id)


func Idle():
	idle = true
	moving = false
	
	dir = Vector2.ZERO
	if randi_range(1, 10) <= 2:  # 20% chance to stop moving/wandering. Might need a better way using energy
		await get_tree().create_timer(randf_range(0.5, 1)).timeout
	
	idle = false


func Wander():
	wandering = true
	moving = true
	
	dir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	await get_tree().create_timer(randf_range(0.15, 0.3)).timeout  # Lower for erratic speed
	
	idle = true
	moving = false
	wandering = false


func Chase():
	print("Chasing! ", moving)
	chasing = true
	moving = true
	
	dir = self.global_position.direction_to(current_target.global_position)


func Attack():
	print("Attacking!")


func Flee():
	print("Fleeing!")


func _on_chosen_dir_updated():
	dir = context_map.chosen_dir


## AI component that judges the situation to choose the best direction to go to.
func situational_awareness():
	if chasing:
		return self.global_position.direction_to(current_target.global_position)
	else:
		return context_map.chosen_dir



# ============ OLD ================== #

#signal player_move()      ## Emitted whenever the player gives movement input ([kbd]'W' 'A' 'S' 'D'[/kbd]).
#signal player_sprint()    ## Emitted whenever the player gives sprinting input ([kbd]'Shift'[/kbd]).
#signal player_attack()    ## Emitted whenever the player gives attack input ([kbd]Left-Click[/kbd]).
#signal player_interact()  ## Emitted whenever the player gives interact input ([kbd]'F'[/kbd]).


### BehaviorTree & Utility Agents AI Variables
#var dir              : Vector2  = Vector2()  ## Current direction.
#var anim_state       : String   = "Move"     ## Current animation state.
#var attacking     : bool     = false      ## Is the entity currently attacking?
#var sprinting     : bool     = false      ## Is the entity currently sprinting?
#var moving        : bool     = false      ## Is the entity currently moving?


### Rotates the interactor's [member Marker2D.rotation].
#func rotate_interactor(direction: Vector2):
	#pass
	##interactor_animator_tree["parameters/Movement/blend_position"] = direction
#
#
#func on_move():
	#pass
#
#
#func on_stop():
	#is_moving = false
#
#
#func on_attack():
	#is_attacking = true
#
#
#func on_attack_finished():
	#is_attacking = false
#
#
#func on_sprint():
	#pass
#
#
#func _on_vision_area_body_entered(target: Node2D) -> void:
	#if target.is_in_group("Player"):
		#is_enemy_nearby = true
		#current_target = target
#
#
#func _on_vision_area_body_exited(target: Node2D) -> void:
	#if target.is_in_group("Player"):
		#is_enemy_nearby = false
		#current_target = null
		
		
		







# NPC FROM EXAMPLE ==========
#extends CharacterBody23D
#
#var is_moving = false
#
## those are being exported so we can modify
## the initial value in the example
#@export var hunger = 0
#@export var stress = 0
#@export var energy = 100
#var is_sleeping = false
#var is_eating = false
#
#var looking_for_food = false
#var looking_for_shelter = false
#
#var has_food_in_pocked = false
#
#var is_safe = true:
	#set(value):
		#is_safe = value
		#if is_safe and looking_for_shelter:
			#looking_for_shelter = false
			#_target = null
			#$body.play("idle")
#
#
#var _target
#
#
#func _process(delta):
	#_handle_energy(delta)
	#_handle_hunger(delta)
	#_handle_stress(delta)
	#_handle_target(delta)
#
#
#func move_to(direction, delta):
	#is_moving = true
	#$body.play("run")
	#if direction.x > 0:
		#turn_right()
	#else:
		#turn_left()
#
  ## warning-ignore:return_value_discarded
	#move_and_collide(direction * delta * 100)
#
#
#func turn_right():
	#if not $body.flip_h:
		#return
#
	#$body.flip_h = false
#
#
#func turn_left():
	#if $body.flip_h:
		#return
#
	#$body.flip_h = true
#
#
#func _handle_energy(delta: float):
	#if is_sleeping:
		#energy += delta * 4
		#if energy >= 100:
			#energy = 100
			#wake_up()
	#else:
		#energy -= delta * 2
		#if energy <= 0:
			#energy = 0
			#sleep()
#
	#$energy_bar.value = energy
#
#
#func _handle_hunger(delta: float):
	#hunger = clampf(hunger + delta * 5, 0, 100)
	#$hunger_bar.value = hunger
#
#
#func _handle_stress(delta: float):
	#if is_safe:
		#stress -= delta * 4
	#else:
		#stress += delta * 2
#
	#stress = clampf(stress, 0, 100)
#
	#$stress_bar.value = stress
#
#
#func _handle_target(delta: float):
	#if is_sleeping:
		#return
	#if not is_instance_valid(_target):
		#_target = null
		## if it's still looking for food, try to find a new target
		#if looking_for_food:
			#find_food()
		#return
#
	#if self.global_position.distance_to(_target.global_position) <= 1:
		#$body.play("idle")
		#if looking_for_food and _target.is_in_group("food"):
			#_target.queue_free()
			#has_food_in_pocked = true
#
		#looking_for_food = false
		#_target = null
#
		#return
#
	#move_to(self.global_position.direction_to(_target.global_position), delta)
#
#
#
#func sleep():
	#$body.play("sleep")
	#is_sleeping = true
#
#
#func wake_up():
	#$body.play("idle")
	#is_sleeping = false
#
#
#func idle():
	#$body.play("idle")
#
#
#func eat():
	#is_eating = true
	#$body/mushroom.show()
	#await get_tree().create_timer(3).timeout
	#hunger = 0
	#$hunger_bar.value = 0
	#has_food_in_pocked = false
	#is_eating = false
	#$body/mushroom.hide()
#
#
#func find_food():
	#looking_for_food = true
	#var closest = _get_closest_food()
	#if closest != null:
		#_target = closest
#
#
#func _get_closest_food():
	#var closest = null
	#var closest_distance = null
	#for food in get_tree().get_nodes_in_group("food"):
		#var dist = self.global_position.distance_to(food.global_position)
		#if closest_distance == null or closest_distance > dist:
			#closest_distance = dist
			#closest = food
#
	#return closest
#
#
#func find_shelter():
	#looking_for_shelter = true
	#var shelter = get_tree().get_nodes_in_group("firepit")[0]
	#_target = shelter
#
#
#
#func _on_utility_ai_agent_top_score_action_changed(top_action_id):
	#print("Action changed: %s" % top_action_id)
#
	#match top_action_id:
		#"idle":
			#idle()
		#"sleep":
			#sleep()
		#"eat":
			#eat()
		#"find_food":
			#find_food()
		#"look_for_shelter":
			#find_shelter()
		#"go_to_sleep":
			#find_shelter()
		#"relax":
			## doesn't need to do anything. Already safe.
			#pass
