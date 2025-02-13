class_name OldField extends Node2D

# TODO - Remaster this with signals and a better hierarchy: World / Managers / FarmManager / MineMan...
@onready var surface = get_parent().get_parent().find_child("Surface")
@onready var area = get_node("Area")
var thread : Thread

func _ready():
	thread = Thread.new()
	position = Vector2(758, 410)  # TODO - Dynamic, save/load, OPP ...


func load_plants():
	for i in range(100):
		var plant = preload("res://Labs/Scenes/Farming Room/OldPlant.tscn").instantiate()  ## WARN - BAD LINE
		plant.get_node("Sprite").texture = get_parent().get_crop_texture("corn")
		
		var area_size_x = area.get_shape().size.x / 2
		var area_size_y = area.get_shape().size.y / 2
		var rand_x = randf_range(position.x - area_size_x + plant.margin_x, position.x + area_size_x - plant.margin_x)
		var rand_y = randf_range(position.y - area_size_y, position.y + area_size_y - plant.margin_y)
		plant.position = Vector2(rand_x, rand_y)
		
		surface.add_child(plant)
