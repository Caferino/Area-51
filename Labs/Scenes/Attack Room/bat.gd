class_name Bat extends Entity
## A [color=brown]Bat[/color], by [color=green]Bizck.

@export var lore        : LoreComponent                  ## The entity's [color=ivory]lore.
@export var heart       : HealthComponent                ## The entity's [color=red]heart.
@export var muscles     : FlyingMammalMovementComponent  ## The entity's [color=salmon]muscles.
@export var effects     : EffectsAnimatorComponent       ## The entity's [color=cornflower]effects.
@export var controller  : EntityController               ## The entity's [color=gray]controller.
@export var body        : BodyComponent                  ## The entity's [color=blue]body.

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
	stamina_stats[GameEnums.STAMINA_STAT.MAX_SPRINT_SPEED] = 120
	stamina_stats[GameEnums.STAMINA_STAT.SPRINT_ACCEL]     =   2
	
	body_pose["Torso"] = [Vector2(0, 0), 0, "parameters/Movement/playback", "Fly", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
	
	spawn()


func spawn():
	var pose = body_pose["Torso"]
	body.limbs["Torso"].animator_tree[pose[2]].travel(pose[3])


## Handles the entity's movement every physics frame.
func _physics_process(_delta: float) -> void:
	muscles.handle_movement(self, controller.dir, controller.sprinting)
