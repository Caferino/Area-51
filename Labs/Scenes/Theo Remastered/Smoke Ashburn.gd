extends Human

## Smoke Ashburn ##

## The Hero of the Realm ##

## Tell Caferino that you have arrived.
## WARN NOTE - Had this in _ready() at first, but, for some weird ass reason,
## it'd not run in the same order in some levels, with the exact same structure.
## My DayNight Lighting.gd script needs the player's camera, and global variable
## Caferino helps grab the player as a variable to access. It'd work sometimes. Weird.
func _enter_tree() -> void:
	Caferino.player = self


## Prepares Smoke's stats and body
func _ready():
	base_stats[GameEnums.STAT.STRENGTH]     = 5
	base_stats[GameEnums.STAT.DEXTERITY]    = 5
	base_stats[GameEnums.STAT.VITALITY]     = 5
	base_stats[GameEnums.STAT.INTELLIGENCE] = 5
	
	stamina_stats[GameEnums.STAMINA_STAT.CAPACITY]         = 100
	stamina_stats[GameEnums.STAMINA_STAT.SPRINT_RATE]      =   2
	stamina_stats[GameEnums.STAMINA_STAT.REGEN_RATE]       =   3
	stamina_stats[GameEnums.STAMINA_STAT.MAX_WALK_SPEED]   =  60
	stamina_stats[GameEnums.STAMINA_STAT.WALK_ACCEL]       =   3
	stamina_stats[GameEnums.STAMINA_STAT.MAX_SPRINT_SPEED] = 150
	stamina_stats[GameEnums.STAMINA_STAT.SPRINT_ACCEL]     =   2
	
	body_pose["Head"]  = [Vector2(0, -13), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
	body_pose["Torso"] = [Vector2(0, 0), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 2.0]
	
	body_accessories["Hat"]    = [Vector2(0, -9), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
	body_accessories["Weapon"] = [Vector2(0, 0), -90, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
	
	spawn()
