extends SoulComponent

## Smoke Ashburn ##

var base_stats = {
	GameEnums.STAT.STRENGTH     : 5,
	GameEnums.STAT.DEXTERITY    : 5,
	GameEnums.STAT.VITALITY     : 5,
	GameEnums.STAT.INTELLIGENCE : 5
	#GameEnums.STAT.MOVE_SPEED   : 150  # ! DEPRECATED
}

## TODO - Someday turn these into ENUMS Caferino, Bizck and Raz hold
## Body fills this, so it's dynamic. Missing or extra limbs...
## ! Problem is, there is really no LeftLeg and RightLeg. Not yet, not for this 2D game
## [Origin Position, State_Machine key, State_Machine travel node, Animator_Tree key, Animator_Tree blend_position, Animator_Tree speed, speed_scale]
var pose = {
	"Head"      : [Vector2(0, -13), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0],
	"Torso"     : [Vector2(0, 0), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 2.0],
	#"LeftLeg"  : [Vector2(0, 0), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0],
	#"RightLeg" : [Vector2(0, 0), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
}

## [Origin Position, State_Machine key, State_Machine travel node, Animator_Tree key, Animator_Tree blend_position, Animator_Tree speed, speed_scale]
var accessories = {
	"Hat"       : [Vector2(0, -9), "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
}
