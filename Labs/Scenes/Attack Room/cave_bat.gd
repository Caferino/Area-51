class_name CaveBat extends Bat
## A [color=magenta]Cave Bat[/color], by [color=green]Bizck.

## Spawns the entity.
func _ready():
	## TASK - Make CaveBat's stats unique from Bat. Did this quick for testing.
	base_stats[GameEnums.STAT.STRENGTH]     = 5
	base_stats[GameEnums.STAT.DEXTERITY]    = 5
	base_stats[GameEnums.STAT.VITALITY]     = 5
	base_stats[GameEnums.STAT.INTELLIGENCE] = 5
	
	stamina_stats[GameEnums.STAMINA_STATS.CAPACITY]         = 100
	stamina_stats[GameEnums.STAMINA_STATS.SPRINT_RATE]      =   2
	stamina_stats[GameEnums.STAMINA_STATS.REGEN_RATE]       =   3
	stamina_stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED]   = 130
	stamina_stats[GameEnums.STAMINA_STATS.WALK_ACCEL]       =   3
	stamina_stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED] = 120
	stamina_stats[GameEnums.STAMINA_STATS.SPRINT_ACCEL]     =   2
	
	body_pose["Torso"] = [Vector2(0, 0), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
	
	spawn()
