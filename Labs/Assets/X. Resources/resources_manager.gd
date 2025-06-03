extends Node

## ResourcePreloaders
var managers : Dictionary = {
	"Armor"      : null,
	"Debris"     : null,
	"Weapons"    : null,
	"Reagents"   : null,
	"Gathering"  : null,
	"Structures" : null
}

## Commonly Used Nodes
var node = {
	"collectable" : preload("res://Labs/Scenes/Collectable Items & Inventory/New Inventory System 1.0/Inventory/collectable.tscn"),
	"gathering"   : preload("res://Labs/Scenes/Crafting & Gathering Tools/gathering_node.tscn"),
	"debris"      : preload("res://Labs/Assets/X. Resources/Reagents/debris.tscn")
}

## StructureManager
var curr_structure : Node2D = null
var curr_area      : Area2D = null
var valid_spot     : bool   = false


func _ready():
	managers["Armor"]      = $Armor
	managers["Debris"]     = $Debris
	managers["Weapons"]    = $Weapons
	managers["Reagents"]   = $Reagents
	managers["Gathering"]  = $Gathering
	managers["Structures"] = $Structures




################# ############# #################
################# ITEMS MANAGER #################
################# ############# #################

func drop_object(manager_name: String, type: String, object_name: String, spawn_position: Vector2, radius: Vector2, scene: Node2D):
	var manager = managers.get(manager_name)
	if manager and manager.has_resource(object_name):
		var item = manager.get_resource(object_name)
		var object = node[type].instantiate()
		
		object.setup(item)
		scene.add_child(object)
		object.global_position = spawn_position
		object.drop(radius)




################# ################## #################
################# STRUCTURES MANAGER #################
################# ################## #################

## Prepare the structure to place, helpful to separate the NPC vs Player's methods
## TODO ATTENTION - I MUST call .queue_free after removing childs everywhere, for memory
func prepare_structure(structure: StringName, scene: Node2D):
	if managers["Structures"].has_resource(structure):
		curr_structure = managers["Structures"].get_resource(structure).instantiate()
		curr_area = curr_structure.find_child("StructureArea").duplicate()
		# NOTE - I first coded all this with multithreading, then normally...,
		# but "is_overlapping_bodies" would not work well on either, it'd always be false,
		# and I think it happened because of how (or when) are collisions calculated.
		# Godot's docs recommend using signals like these instead.
		# TBD - Can I still use multithreading for the instancing and this or nah?
		curr_area.connect("body_exited", _on_area_body_exit)
		curr_area.connect("body_entered", _on_area_body_enter)
		curr_structure.find_child("StructureArea").free()
		scene.add_child(curr_area)


## Moves the structure area to the randomly-generated-and-given spot.
func move_structure_area(spot: Vector2):
	if curr_area:
		curr_area.global_position = spot


## Places the structure in the given global_position and adds it to the scene
## TODO - Maybe place it somewhere that makes sense, for future management
## Somewhere I can easily loop through in my remastered LevelComponent
func place_structure(global_position: Vector2, scene: Node2D):
	valid_spot = false
	scene.add_child(curr_structure)  # Must run first, or global_position'll be nuts (The Void's)
	curr_structure.global_position = global_position
	curr_area.free()
	curr_structure = null
	curr_area = null


## Runs whenever the structure's area receives an overlapping body.
func _on_area_body_enter(_body: Node2D):
	valid_spot = false


## Runs whenever the structure's area loses an overlapping body.
func _on_area_body_exit(_body: Node2D):
	## NOTE - This check protects the variable valid_spot from changing in case the area
	## was overlapping two or more bodies, and after moving to the next random spot, it
	## exited one, but not the other(s), making the AI think it is in a valid_spot,
	## but it isn't, because it is still overlapping with bodies that haven't run their exit.
	if not curr_area.has_overlapping_bodies():
		valid_spot = true
