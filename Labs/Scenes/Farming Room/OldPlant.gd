class_name OldPlant extends Node2D

@onready var sprite = $Sprite
@onready var leaves = $Leaves
var water_level = 0
var growth_stages = 5
var current_stage = 0
var texture = null
var margin_x = 5  # TODO - Per crop, make dynamic
var margin_y = 8  # TODO - Per crop, make dynamic
var Hframes = 6   # TODO - Per crop, make dynamic
var Vframes = 1
var rng_group
var rot_center = 0


# TODO - Each plant having a long script like this doesn't feel right. DRY.
# Maybe manage everything here through a manager / interface or whatever?
# This script should only hold the variables above and func ready, no more, imo

func _ready():
	add_to_group("Plants", true)  # TODO - Dynamic name per field
	rng_group = randi_range(1, 5)  # TODO - Make it a variable so no weird shit happens someday
	current_stage = rng_group
	sprite.frame = current_stage


func create_plant(wl, gs, cs, t, Hf, Vf):  # TODO Is this safe? Could players spawn their own?
	water_level = wl
	growth_stages = gs
	current_stage = cs
	texture = t
	Hframes = Hf
	Vframes = Vf


# TODO - Patterns are obvious... But what if this function received two RNs?
# ! Or use perlin noise and a seed / % chance that changes once with RNG
func grow(rand_growth):
	if rand_growth == rng_group:
		current_stage += 1
		if current_stage > 1: z_index = 1
		if current_stage > growth_stages:
			current_stage = 0
			z_index = 0
		sprite.frame = current_stage
		shake()


func tilt(direction = 0, strength = 0.2, action = null):
	rot_center = direction
	if action:
		if action == "shake" : shake(strength)
		elif action == "tilt_back" : tilt_back(strength)


func tilt_back(strength = 0.2):
	rot_center = 0
	if current_stage > 1:
		var tween = create_tween()
		tween.stop()
		tween.tween_property(self, "rotation", rot_center, strength).set_trans(Tween.TRANS_LINEAR)
		tween.play()


func shake(strength = 0.2):
	if current_stage > 1:
		var tween = create_tween()
		tween.stop()
		tween.tween_property(self, "rotation", rot_center, strength).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self, "rotation", rot_center + 0.1, strength).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self, "rotation", rot_center - 0.1, strength * 2).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self, "rotation", rot_center, strength).set_trans(Tween.TRANS_LINEAR)
		tween.play()


func drop_leaves():
	if current_stage > 1:
		match current_stage:
			2:
				leaves.amount = 2
			3:
				leaves.amount = 3
			4:
				leaves.amount = 6
			5:
				leaves.amount = 8
		
		leaves.emitting = true
		leaves.restart()


func take_damage(weapon_type):
	var strength = 0.025
	# TODO - Any way to stop the growth's shake while getting cut at the same time?
	shake(strength)
	if weapon_type == GameEnums.WEAPON_TYPE.SLASH:
		drop_leaves()
		await get_tree().create_timer(strength * 5).timeout
		current_stage = 1
		sprite.frame = 1
		z_index = 0


func interact(direction = 0, strength = 0.2, action = null):
	tilt(direction, strength, action)
