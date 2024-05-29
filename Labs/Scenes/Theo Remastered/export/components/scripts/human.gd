class_name Human extends CharacterBody2D
## A human being, by [color=brown]Caferino.

@export var lore        : LoreComponent              ## The entity's [color=ivory]lore.
@export var health      : HealthComponent            ## The entity's [color=red]heart.
@export var muscles     : HumanoidMovementComponent  ## The entity's [color=salmon]muscles.
@export var controller  : PlayerControllerComponent  ## The entity's [color=gold]player controller.
@export var body        : BodyComponent              ## The entity's [color=blue]body

## The entity's base stats.
var base_stats = {
	GameEnums.STAT.STRENGTH     : 5,
	GameEnums.STAT.DEXTERITY    : 5,
	GameEnums.STAT.VITALITY     : 5,
	GameEnums.STAT.INTELLIGENCE : 5
}

## The entity's stamina stats.
var stamina_stats = {
	GameEnums.STAMINA_STATS.CAPACITY         : 100,  # %
	GameEnums.STAMINA_STATS.SPRINT_RATE      :   2,  # -units/s
	GameEnums.STAMINA_STATS.REGEN_RATE       :   3,  # +units/s  # TODO - Small pause b4 recharging
	GameEnums.STAMINA_STATS.MAX_WALK_SPEED   :  60,
	GameEnums.STAMINA_STATS.WALK_ACCEL       :   3,
	GameEnums.STAMINA_STATS.MAX_SPRINT_SPEED : 150,
	GameEnums.STAMINA_STATS.SPRINT_ACCEL     :   2
}

## The entity's body pose.
## [br][br]
## [b]Defined as:[/b]
## [codeblock]
## body_pose: Dictionary<String, Variant> = {
##     [0] "marker2D_position": Vector2
##     [1] "marker2D_rotation": rotation_degrees,
##     [2] "animation_tree_parameter_path": "parameters/Movement/playback",  # Example string
##     [3] "animation_tree_state": "Idle",  # Example string
##     [4] "animation_tree_blend_position_path": "parameters/Movement/Idle/blend_position",  # Example string
##     [5] "animation_tree_blend_position_direction": Vector2(0, 1),  # Example vector
##     [6] "animation_tree_time_scale_path": "parameters/TimeScale/scale",  # Example string
##     [7] "animation_tree_time_scale_speed_scale": 2.0,  # Example float
## }
var body_pose = {
	"Head"      : [Vector2(0, -13), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0],
	"Torso"     : [Vector2(0, 0), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 2.0]
}  # TODO - Make it dynamic. Empty at first, or with a default structure for every human being

## The entity's accessories.
## [br][br]
## [b]Defined as:[/b]
## [codeblock]
## body_accessories: Dictionary<String, Variant> = {
##     [0] "marker2D_position": Vector2
##     [1] "marker2D_rotation": rotation_degrees,
##     [2] "animation_tree_parameter_path": "parameters/Movement/playback",  # Example string
##     [3] "animation_tree_state": "Idle",  # Example string
##     [4] "animation_tree_blend_position_path": "parameters/Movement/Idle/blend_position",  # Example string
##     [5] "animation_tree_blend_position_direction": Vector2(0, 1),  # Example vector
##     [6] "animation_tree_time_scale_path": "parameters/TimeScale/scale",  # Example string
##     [7] "animation_tree_time_scale_speed_scale": 2.0,  # Example float
## }
var body_accessories = {
	"Hat"       : [Vector2(0, -9), 0, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0],
	"Weapon"    : [Vector2(0, 0), -90, "parameters/Movement/playback", "Idle", "parameters/Movement/Idle/blend_position", Vector2(0, 1), "parameters/TimeScale/scale", 1.0]
}


## Connects the following entity's component signals:
## [br]
## [br] [signal MeleeWeapon.attack_finished]
## [br] [signal BodyComponent.limb_interact]
## [br] [signal PlayerControllerComponent.attacked]
## [br] [signal PlayerControllerComponent.player_moved]
## [br] [signal PlayerControllerComponent.player_interact]
func spawn():
	body.gear["MeleeWeapon"].attack_finished.connect(_on_attack_finished)
	body.limb_interact.connect(_on_limb_interact)
	controller.player_move.connect(_on_player_move)
	controller.player_attack.connect(_on_player_attack)
	controller.player_interact.connect(_on_player_interact)


## Runs whenever the entity moves.
func _on_player_move():
	muscles.handle_movement(self)
	controller.rotate_interactor(position, muscles.last_direction)


## Runs whenever the entity attacks.
func _on_player_attack():
	if !controller.is_attacking:
		controller.is_attacking = true
		muscles.stop(self)
		muscles.attack(body.gear["MeleeWeapon"], body.limbs["Torso"].animator, body.limbs["Head"].animator)


## Runs after the entity's most recent attack ends.
func _on_attack_finished():
	controller.is_attacking = false


## Runs whenever a body limb interacts with something.
func _on_limb_interact(entered: bool, limb_name: String, area: Area2D):
	if area.is_in_group("Plants"):
		if entered and limb_name == "left_leg"    : area.interact(-0.1, 0.2, "shake")
		elif limb_name == "left_leg"              : area.interact( 0.0, 0.2, "tilt_back")
		elif entered and limb_name == "right_leg" : area.interact( 0.1, 0.2, "shake")
		else                                      : area.interact( 0.0, 0.2, "tilt_back")


## Runs whenever the player (if controlled by one), interacts with something.
func _on_player_interact():
	var interactables = controller.interactor_area.get_overlapping_areas()
	for interactable in interactables:
		if interactable.is_in_group("Interactive"):
			if interactable.is_in_group("Tree"):
				interactable.interact("hatchet")
