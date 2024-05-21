extends CharacterBody2D

## This system works like a real brain. The limbs await collisions and inputs
## which they send here, the brain, to process and make a decision, the output,
## the action to be executed. Every entity has a set of defined components and 
## variables it needs to be what it is.

# TODO - What if limb_interact(limb, object) and player_interact() ? 
# This way, you might be able to control any entity in the game
signal limb_interact(limb, object)
signal player_interact()

@export var lore        : LoreComponent
@export var player      : PlayerControllerComponent
@export var health      : HealthComponent
@export var movement    : HumanoidMovementComponent
@export var weapon      : WeaponComponent
@export var body        : BodyComponent
@export var accessories : AccessoriesComponent

var base_stats = {
	GameEnums.STAT.STRENGTH: 5,
	GameEnums.STAT.DEXTERITY: 5,
	GameEnums.STAT.VITALITY: 5,
	GameEnums.STAT.INTELLIGENCE: 5,
	GameEnums.STAT.MOVE_SPEED: 150
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


func _ready():
	movement.stamina.setup(stamina_stats)
	body.connect_limbs()
