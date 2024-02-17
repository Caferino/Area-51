extends Node2D

class_name Plant

@onready var sprite = get_node("Sprite")
var water_level = 0
var growth_stages = 5
var current_stage = 0
var texture = null
var margin_x = 5  # TODO Per crop, make dynamic
var margin_y = 8  # TODO Per crop, make dynamic
var Hframes = 6   # TODO Per crop, make dynamic
var Vframes = 1
var rng_group
var rot_center = 0


func _ready():
	add_to_group("Plants", true)  # TODO - Dynamic name per field
	rng_group = randi_range(1, 5)  # TODO - Make it a variable so no weird shit happens someday
	# get_parent().get_node("Theo").get_node("Character").connect("plant_collision", shake)


func create_plant(wl, gs, cs, t, Hf, Vf):  # TODO Is this safe? Could players spawn their own?
	water_level = wl
	growth_stages = gs
	current_stage = cs
	texture = t
	Hframes = Hf
	Vframes = Vf


func grow(rand_growth):
	if rand_growth == rng_group:
		current_stage += 1
		if current_stage > 1: z_index = 1
		if current_stage > growth_stages:
			current_stage = 0
			z_index = 0
		sprite.frame = current_stage
		shake()


func tilt(strength):
	rot_center = strength
	shake()


func tilt_back():
	rot_center = 0
	if current_stage > 1:
		var tween = create_tween()
		tween.stop()
		tween.tween_property(self, "rotation", rot_center, 0.2).set_trans(Tween.TRANS_LINEAR)
		tween.play()


func shake():
	if current_stage > 1:
		var tween = create_tween()
		tween.stop()
		tween.tween_property(self, "rotation", rot_center, 0.2).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self, "rotation", rot_center + 0.1, 0.2).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self, "rotation", rot_center - 0.1, 0.4).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self, "rotation", rot_center, 0.2).set_trans(Tween.TRANS_LINEAR)
		tween.play()
