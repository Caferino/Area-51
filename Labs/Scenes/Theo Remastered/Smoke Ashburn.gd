extends CharacterBody2D

## This system works like a real brain. The limbs await collisions and inputs
## which they send here, the brain, to process and make a decision, the output,
## the action to be executed. Every entity has a set of defined components and 
## variables it needs to be what it is.

@export var lore        : LoreComponent
@export var soul        : SoulComponent
@export var health      : HealthComponent
@export var attack      : AttackComponent
@export var movement    : HumanoidMovementComponent
@export var controller  : PlayerControllerComponent
@export var body        : BodyComponent
@export var weapon      : WeaponComponent
@export var accessories : AccessoriesComponent


func _ready():
	movement.initiate(soul.stamina_stats)
	body.limb_interact.connect(on_limb_interact)
	spawn()


func spawn():
	for limb in body.limbs:
		# TODO ! Don't like the idea of searching twice and a lot of times. Could enums help here?
		if limb in body.limbs and limb in soul.pose:
			if body.limbs[limb].get_child(1) is AnimatedSprite2D:
				movement.wake_up(body.limbs[limb].get_child(1))
			movement.move_limb(body.limbs[limb], soul.pose[limb])


## It works, it's just that you need to wait a second because the children load first
func on_limb_interact(test, tes):
	print("A limb just interacted", test, tes)
