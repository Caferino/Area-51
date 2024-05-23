extends CharacterBody2D

## This system works like a real brain. The limbs await collisions and inputs
## which they send here, the brain, to process and make a decision, the output,
## the action to be executed. Every entity has a set of defined components and 
## variables it needs to be what it is.

@export var lore        : LoreComponent
@export var soul        : SoulComponent
@export var health      : HealthComponent
@export var attack      : AttackComponent
@export var muscles     : HumanoidMovementComponent
@export var controller  : PlayerControllerComponent
@export var body        : BodyComponent
@export var weapon      : WeaponComponent
@export var accessories : AccessoriesComponent


func _ready():
	spawn()


func spawn():
	muscles.initiate(soul.stamina_stats)
	body.limb_interact.connect(on_limb_interact)
	
	for limb in body.limbs:
		spawn_limbs(limb)
		spawn_accessories(limb)


func spawn_limbs(limb):
	if limb in body.limbs and limb in soul.pose:
		muscles.move_limb(body.limbs[limb], soul.pose[limb])


func spawn_accessories(limb):
	var accessories = body.limbs[limb].get_child(0).find_child("AccessoriesComponent")
	if accessories:
		for accessory in accessories.get_children():
			muscles.move_limb(accessory, soul.accessories[accessory.name])


## It works, it's just that you need to wait a second because the children load first
func on_limb_interact(test, tes):
	print("A limb just interacted", test, tes)
