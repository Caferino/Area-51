extends SoulComponent

## Smoke Ashburn ##

var base_stats = {
	GameEnums.STAT.STRENGTH     : 5,
	GameEnums.STAT.DEXTERITY    : 5,
	GameEnums.STAT.VITALITY     : 5,
	GameEnums.STAT.INTELLIGENCE : 5,
	GameEnums.STAT.MOVE_SPEED   : 150  # ! DEPRECATED
}

var stamina_stats = {
	GameEnums.STAMINA_STATS.CAPACITY         : 100,  # %
	GameEnums.STAMINA_STATS.SPRINT_RATE      :   2,  # -units/s
	GameEnums.STAMINA_STATS.REGEN_RATE       :   3,  # +units/s
	GameEnums.STAMINA_STATS.MAX_WALK_SPEED   :  10,
	GameEnums.STAMINA_STATS.WALK_ACCEL       :   2,
	GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED :  20,
	GameEnums.STAMINA_STATS.SPRINT_ACCEL     :  15,
	GameEnums.STAMINA_STATS.DEACCEL          :   6
}

## TODO - Someday turn these into ENUMS Caferino, Bizck and Raz hold
## Body fills this, so it's dynamic. Missing or extra limbs...
## ! Problem is, there is really no LeftLeg and RightLeg. Not yet, not for this 2D game
## [Origin Position, State_Machine key, State_Machine travel node, Animator_Tree key, Animator_Tree blend_position, Animator_Tree speed, speed_scale]
var pose = {
	"Head"      : [Vector2(0, -15), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0],
	"Torso"     : [Vector2(0, 0), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0],
	#"LeftLeg"  : [Vector2(0, 0), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0],
	#"RightLeg" : [Vector2(0, 0), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
}

## [Origin Position, State_Machine key, State_Machine travel node, Animator_Tree key, Animator_Tree blend_position, Animator_Tree speed, speed_scale]
var accessories = {
	"Hat"       : [Vector2(0, -9), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
}
