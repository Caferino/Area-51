class_name Bat extends Entity
## A [color=brown]Bat[/color], by [color=green]Bizck.

@export var lore        : LoreComponent                  ## The entity's [color=ivory]lore.
@export var heart       : HealthComponent                ## The entity's [color=red]heart.
@export var muscles     : FlyingMammalMovementComponent  ## The entity's [color=salmon]muscles.
@export var effects     : EffectsAnimatorComponent       ## The entity's [color=cornflower]effects.
@export var controller  : EntityController               ## The entity's [color=gray]controller.
@export var body        : BodyComponent                  ## The entity's [color=blue]body.
@export var particles   : ParticlesComponent             ## The entity's [color=brown] blood.
@onready var tween      : Tween = create_tween()         ## Exclusively for knockbacks.

var stunned  : bool  = false
var stun_dur : float = 1.0


func _ready():
	base_stats[GameEnums.STAT.STRENGTH]     = 5
	base_stats[GameEnums.STAT.DEXTERITY]    = 5
	base_stats[GameEnums.STAT.VITALITY]     = 5
	base_stats[GameEnums.STAT.INTELLIGENCE] = 5
	
	## The random mass of this creature (bat - 5g to 200g)
	var mass = randi() % 196 + 5  ## grams
	stamina_stats[GameEnums.STAMINA_STAT.CAPACITY]         = 100
	stamina_stats[GameEnums.STAMINA_STAT.SPRINT_RATE]      =   2
	stamina_stats[GameEnums.STAMINA_STAT.REGEN_RATE]       =   3
	stamina_stats[GameEnums.STAMINA_STAT.MAX_WALK_SPEED]   =  60
	stamina_stats[GameEnums.STAMINA_STAT.WALK_ACCEL]       =   3
	stamina_stats[GameEnums.STAMINA_STAT.MAX_SPRINT_SPEED] = 120
	stamina_stats[GameEnums.STAMINA_STAT.SPRINT_ACCEL]     =   2
	stamina_stats[GameEnums.STAMINA_STAT.WEIGHT]           = mass
	stamina_stats[GameEnums.STAMINA_STAT.BLOOD]            = mass * 0.07  ## mililiters
	
	## Blood preparation
	particles.emitter.amount = Caferino.blood_amount(mass)
	
	body_pose["Torso"] = [Vector2(0, 0), 0, "parameters/Movement/playback", "Fly", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
	
	prepare_size(mass, 5, 200, 0.5, 1)
	prepare_fluids(mass, particles)
	spawn()


func spawn():
	tween.kill()    ## Avoids a weird error where @onready tweens must be used quickly
	var pose = body_pose["Torso"]
	body.limbs["Torso"].animator_tree[pose[2]].travel(pose[3])


## Handles the entity's movement every physics frame.
func _physics_process(_delta: float) -> void:
	if !stunned:
		muscles.handle_movement(self, controller.dir, controller.sprinting)


## TODO - Might move hurt() and knockback() to Entity.gd if more entities can share it.
## If they don't, I could simply overwrite them with a method in such entity's personal script.
## Could take a little while to adapt the Animators, move the variables, etc.
func hurt(weapon):
	stunned = true
	effects.animator.play("effects/hit_flash")
	var direction = (global_position - weapon.global_position).normalized()
	if randi_range(1, 10) <= 5:   # TODO - Create a Dice File with different dice rollers. Crit Dmg
		body.limbs["Torso"].get_child(2).play("cave_bat/hurt")
		knockback(direction, 75, stun_dur)
	else:
		body.limbs["Torso"].get_child(2).play("cave_bat/hurt_critical")
		knockback(direction, 100, stun_dur)
	
	## Blood splatter
	var damage_type = 1  ## WIP - if damage_type should splatter blood, like a sword hit, but not poison, execute
	if damage_type: 
		bleed(direction)
	
	await get_tree().create_timer(stun_dur).timeout
	stunned = false


func knockback(direction: Vector2, strength: float, stun_dur: float = 1.0):
	tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", global_position + direction * strength, stun_dur)
	tween.play()


func bleed(direction: Vector2):
	particles.emitter.restart()
	particles.emitter.process_material.direction = Vector3(direction.x, direction.y, 0)
	particles.emitter.emitting = true  ## Should be One-Shot, otherwise, WIP
