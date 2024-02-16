extends Node2D

class Crop:
	var water_level = 0
	var growth_stage = 0
	var texture = null
	var Hframes = 6
	var Vframes = 1

const rng_groups = 5
var stage = 0

@onready var crops_manager = get_node(".")
# @onready var surface = %Surface
var crops = ["corn"]
var crop_location = "res://Labs/Scenes/Farming Room/"  # TODO - "Seed Bank DB"
var crop_textures = {}

var farm_fields = []


func _ready():
	load_crop_textures()
	load_fields(get_node("."))  # Current node
	fill_fields()  # TODO - Make this dynamic in the future


func load_crop_textures():
	for crop in crops:
		crop_textures[crop] = load(crop_location + crop + ".png")


func load_fields(node):
	for child in node.get_children():
		if child is Field:
			child.add_to_group("Fields", true)
			farm_fields.append(child)


func fill_fields():
	get_tree().call_group("Fields", "load_plants")


# =========================================== #
# ===|               HELPERS             |=== #
# =========================================== #

func get_crop_texture(crop):
	return crop_textures.get(crop)


func _on_day_night_cycle_timeout():
	var rand_growth = randi_range(1, rng_groups)
	get_tree().call_group("Plants", "grow", rand_growth)
