extends CharacterBody2D

signal health_depleted
const DAMAGE_RATE = 5.0
var health = 100.0

func _ready():
	%BodyAnimatorTree.get("parameters/playback").travel("Idle")
	%HeadAnimatorTree.get("parameters/playback").travel("Idle")
	%BodyAnimatorTree.set("parameters/Idle/blend_position", Vector2(0, 1))
	%HeadAnimatorTree.set("parameters/Idle/blend_position", Vector2(0, 1))

func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	velocity = direction * 500
	
	if velocity == Vector2.ZERO:
		%BodyAnimatorTree.get("parameters/playback").travel("Idle")
		%HeadAnimatorTree.get("parameters/playback").travel("Idle")
		pass
	else:
		%HeadAnimatorTree.get("parameters/playback").travel("Walk")
		%HeadAnimatorTree.set("parameters/Idle/blend_position", direction)
		%HeadAnimatorTree.set("parameters/Walk/blend_position", direction)
		
		%BodyAnimatorTree.get("parameters/playback").travel("Walk")
		%BodyAnimatorTree.set("parameters/Idle/blend_position", direction)
		%BodyAnimatorTree.set("parameters/Walk/blend_position", direction)
		move_and_slide()
	#
	#if Input.is_action_pressed("ATTACK"): 
		#sword.play(sword_state)
	#else:
		#sword.play("RESET")
		#match direction:
			#Vector2(0, 1): set_animation("walk", "down")
			#Vector2(0, -1): set_animation("walk", "up")
			#Vector2(-1, 0): set_animation("walk", "left")
			#Vector2(1, 0): set_animation("walk", "right")
			#_:
				#if Input.is_action_just_released("MOVE_DOWN"): set_animation("idle", "down")
				#elif Input.is_action_just_released("MOVE_UP"): set_animation("idle", "up")
				#elif Input.is_action_just_released("MOVE_LEFT"): set_animation("idle", "left")
				#elif Input.is_action_just_released("MOVE_RIGHT"): set_animation("idle", "right")
	#
	#if Input.is_action_pressed("ATTACK"): sword.play(sword_state)
	#else: sword.play("RESET")



	
	# var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	# if overlapping_mobs.size() > 0:
		# health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		# %ProgressBar.value = health
		# if health <= 0.0:
			# health_depleted.emit()
