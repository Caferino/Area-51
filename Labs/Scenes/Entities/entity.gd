class_name Entity extends CharacterBody2D
## An [color=white]entity[/color], by [color=white]Alcarodia.

## This is where the general stats of every entity/mob can go:
## e.x.: Level... (What if not every entity has stamina, speed, intelligence, dexterity, etc.?)
## What do all entities share in common other than a Level? HP?
## Keep those things on their respective entity files or create the default values here?

## The entity's base stats.
var base_stats: Dictionary = {
	GameEnums.STAT.STRENGTH     : 5,
	GameEnums.STAT.DEXTERITY    : 5,
	GameEnums.STAT.VITALITY     : 5,
	GameEnums.STAT.INTELLIGENCE : 5
}

## The entity's stamina stats.
var stamina_stats: Dictionary = {
	GameEnums.STAMINA_STAT.CAPACITY         : 100,  # %
	GameEnums.STAMINA_STAT.SPRINT_RATE      :   2,  # -units/s
	GameEnums.STAMINA_STAT.REGEN_RATE       :   3,  # +units/s  # TODO - Small pause b4 recharging
	GameEnums.STAMINA_STAT.MAX_WALK_SPEED   :  60,
	GameEnums.STAMINA_STAT.WALK_ACCEL       :   3,
	GameEnums.STAMINA_STAT.MAX_SPRINT_SPEED : 120,
	GameEnums.STAMINA_STAT.SPRINT_ACCEL     :   2,
	GameEnums.STAMINA_STAT.ROLL_SPEED       : 200,
	GameEnums.STAMINA_STAT.WEIGHT           :   0,  ## grams
	GameEnums.STAMINA_STAT.BLOOD            :   0,  ## mililiters
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
var body_pose: Dictionary = {}

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
var body_accessories: Dictionary = {}


func prepare_size(mass: int, min_mass: int, max_mass: int, min_scale: float, max_scale: float):
	var t = clamp((mass - min_mass) / float(max_mass - min_mass), 0.0, 1.0)
	var scale_value = lerp(min_scale, max_scale, t)
	self.scale = Vector2.ONE * scale_value


func prepare_fluids(mass: int, particles: ParticlesComponent):
	particles.emitter.amount = int(min((mass / 50000.0) * 100.0 + 8, 100.0))
