extends Node

## Usually, adding children to the level is messy; it usually requires to spam
## "get_parent()" and more. This Manager should solve that, it should hold
## a reference to the current level(s) to help with, transitions, spawns...

## To keep it simple, I only need one current level at the time in this game,
## however, in the future, I might use an array to deal with multiple levels.
## I don't know how, haven't designed it yet, but it could open for potential
## cool stuff; managing lands from home, controlling NPCs very far away...
static var temp_rooms_root : String = "res://Labs/Scenes/Dungeons/Temp Run/"
static var rooms_root      : String = "res://Labs/Scenes/Dungeons/Dungeon Set 1/"
var curr_level             : Level  = null
var main_dungeon           : Node2D = null
var curr_dungeon           : Dictionary  = {}  ## DEPRECATED


# Removes all saved rooms between runs/floors
func clear_saved_rooms() -> void:
	var dir = DirAccess.open(temp_rooms_root)
	if not dir:
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			push_error("Found directory: " + file_name)
		else:
			dir.remove(file_name)
		file_name = dir.get_next()


func set_main_dungeon(node: Node2D):
	main_dungeon = node


# Directly switch the current_level, useful for rooms/levels outside dungeons.
func current_level(level: Level):
	curr_level = level


# Switches the current_level given the id of a current_dungeon's room/level.
func switch_current_level(id: int):
	curr_level = curr_dungeon[id]


# Clears the current_level variable, for whatever use it can give in the future.
func remove_current_level():
	curr_level = null


# Adds a level to the current_dungeon given its id. DEPRECATED
#func add_level(level: Level, id: int):
	#curr_dungeon[id] = level


# Removes a level to the current_dungeon given its id.
func remove_level(id: int):
	curr_dungeon.erase(id)


# Clears the current_dungeon dictionary.
func clear_levels() -> void:
	curr_dungeon.clear()


func move_player(player: Entity, area: Area2D) -> void:
	## TODO - Maybe add a little transition animation, a fade in/out, blink
	
	## WARNING NOTE - I KNOW THERE IS A SMALL FREEZE WHEN ENTERING A DOOR. IT IS THE TILEMAPLAYERS
	## AND ITS COLLISIONSHAPES, THIS GETS FIXED IN GODOT 4.5, DO NOT WORRY, ISN'T YOU, IT'S GODOT
	curr_level.space.entities.remove_child(player)
	
	var packed_room = PackedScene.new()
	if packed_room.pack(curr_level) == OK:
		ResourceSaver.save(packed_room, "res://Labs/Scenes/Dungeons/Temp Run/" + str(curr_level.id) + ".tscn")
	packed_room.take_over_path("res://Labs/Scenes/Dungeons/Temp Run/" + str(curr_level.id) + ".tscn")
	curr_level.queue_free()
	
	var new_room = ResourceLoader.load("res://Labs/Scenes/Dungeons/Temp Run/" + str(area.id) + ".tscn").instantiate()
	main_dungeon.add_child(new_room)
	curr_level = new_room
	
	
	curr_level.space.entities.add_child(player)
	player.global_position = area.goes_to


#func add_player(player: Entity, area: Area2D):
	#pass


func spawn(object: Node2D, spot: Node2D):
	if object.get_parent():
		#print("Reparenting...")  ## DEBUG
		object.reparent(curr_level)
	else:
		#print("Directly adding object to the level...")  ## DEBUG
		curr_level.add_child(object)
	object.global_position = spot.global_position


## WARN TODO - I can foresee issues when dealing with multiple levels.
## How to know in which one to spawn or add the child? Keep track of them...
## For this... Do children inherit the group(s) of the parent node? That'd fix all
