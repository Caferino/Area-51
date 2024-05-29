extends Human

## Smoke Ashburn ##

func _ready():
	base_stats[GameEnums.STAT.STRENGTH]     = 5
	base_stats[GameEnums.STAT.DEXTERITY]    = 5
	base_stats[GameEnums.STAT.VITALITY]     = 5
	base_stats[GameEnums.STAT.INTELLIGENCE] = 5
	
	stamina_stats[GameEnums.STAMINA_STATS.CAPACITY]         = 100
	stamina_stats[GameEnums.STAMINA_STATS.SPRINT_RATE]      =   2
	stamina_stats[GameEnums.STAMINA_STATS.REGEN_RATE]       =   3
	stamina_stats[GameEnums.STAMINA_STATS.MAX_WALK_SPEED]   =  60
	stamina_stats[GameEnums.STAMINA_STATS.WALK_ACCEL]       =   3
	stamina_stats[GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED] = 150
	stamina_stats[GameEnums.STAMINA_STATS.SPRINT_ACCEL]     =   2
	
	body_pose["Head"]  = [Vector2(0, -13), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
	body_pose["Torso"] = [Vector2(0, 0), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 2.0]
	spawn()
