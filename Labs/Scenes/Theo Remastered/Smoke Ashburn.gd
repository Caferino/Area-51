extends CharacterBody2D

## Smoke Ashburn ##

@export var lore        : LoreComponent
@export var health      : HealthComponent
@export var weapon      : AttackComponent
@export var muscles     : HumanoidMovementComponent
@export var controller  : PlayerControllerComponent
@export var body        : BodyComponent

var base_stats = {
	GameEnums.STAT.STRENGTH     : 5,
	GameEnums.STAT.DEXTERITY    : 5,
	GameEnums.STAT.VITALITY     : 5,
	GameEnums.STAT.INTELLIGENCE : 5
}

var stamina_stats = {
	GameEnums.STAMINA_STATS.CAPACITY         : 100,  # %
	GameEnums.STAMINA_STATS.SPRINT_RATE      :   2,  # -units/s
	GameEnums.STAMINA_STATS.REGEN_RATE       :   3,  # +units/s  # TODO - Small pause b4 recharging
	GameEnums.STAMINA_STATS.MAX_WALK_SPEED   :  10,
	GameEnums.STAMINA_STATS.WALK_ACCEL       :   2,
	GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED :  20,
	GameEnums.STAMINA_STATS.SPRINT_ACCEL     :  15,
	GameEnums.STAMINA_STATS.DEACCEL          :   6,
}

# [Origin Position, Rotation, State_Machine key, State_Machine travel node, Animator_Tree key, Animator_Tree blend_position, Animator_Tree speed, speed_scale]
var body_pose = {
	"Head"      : [Vector2(0, -13), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0],
	"Torso"     : [Vector2(0, 0), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 2.0]
}

var body_accessories = {
	"Hat"       : [Vector2(0, -9), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0],
	"Weapon"    : [Vector2(0, 0), -90, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
}


func _ready():
	spawn()


func spawn():
	body.limb_interact.connect(_on_limb_interact)
	controller.player_moved.connect(_on_player_moved)


## It works, it's just that you need to wait a second because the children load first
func _on_limb_interact(test, tes):
	print("A limb just interacted", test, tes)


func _on_player_moved():
	muscles.handle_movement(self)


func _physics_process(_delta):
	move_and_slide()
