class_name CaveBat extends Bat
## A [color=magenta]Cave Bat[/color], by [color=green]Bizck.

## Spawns the entity.
func _ready():
	## The random mass of this creature (cave bat - 30g to 1.5kg)
	var mass = randi() % 1471 + 30  ## grams
	
	## TASK - Make CaveBat's stats unique from Bat. Did this quick for testing.
	base_stats[GameEnums.STAT.STRENGTH]     = 5
	base_stats[GameEnums.STAT.DEXTERITY]    = 5
	base_stats[GameEnums.STAT.VITALITY]     = 5
	base_stats[GameEnums.STAT.INTELLIGENCE] = 5
	
	stamina_stats[GameEnums.STAMINA_STAT.CAPACITY]         = 100
	stamina_stats[GameEnums.STAMINA_STAT.SPRINT_RATE]      =   2
	stamina_stats[GameEnums.STAMINA_STAT.REGEN_RATE]       =   3
	stamina_stats[GameEnums.STAMINA_STAT.MAX_WALK_SPEED]   = 130
	stamina_stats[GameEnums.STAMINA_STAT.WALK_ACCEL]       =   3
	stamina_stats[GameEnums.STAMINA_STAT.MAX_SPRINT_SPEED] = 120
	stamina_stats[GameEnums.STAMINA_STAT.SPRINT_ACCEL]     =   2
	stamina_stats[GameEnums.STAMINA_STAT.WEIGHT]           = mass
	stamina_stats[GameEnums.STAMINA_STAT.BLOOD]            = mass * 0.07
	
	## Blood preparation
	#particles.emitter.amount = Caferino.blood_amount(mass)
	
	body_pose["Torso"] = [Vector2(0, 0), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
	
	prepare_size(mass, 30, 1500, 0.75, 1.25)
	prepare_fluids(mass, particles)
	spawn()
