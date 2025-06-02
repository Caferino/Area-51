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
var curr_dungeon           : Dictionary  = {}


# Saves a room to the temporary rooms directory
static func save_room(room: Node, room_name: String) -> void:
	var packed_scene = PackedScene.new()
	packed_scene.pack(room)
	DirAccess.make_dir_absolute(temp_rooms_root) # In case the user deleted it
	var scene_path = temp_rooms_root.path_join(room_name) + ".tscn"
	ResourceSaver.save(packed_scene, scene_path)


# Attempts to load a room from the temporary rooms directory, and falls back on
# loading them from their regular directory
func load_room(room_name: String) -> Node:
	var saved_room_exists := FileAccess.file_exists(temp_rooms_root.path_join(room_name) + ".tscn")
	var scene_path = temp_rooms_root.path_join(room_name) + ".tscn" 
	if scene_path != saved_room_exists: 
		rooms_root.path_join(room_name) + ".tscn"
	var packed_scene := load(scene_path) as PackedScene
	return packed_scene.instantiate()


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


# Directly switch the current_level, useful for rooms/levels outside dungeons.
func current_level(level: Level):
	curr_level = level


# Switches the current_level given the id of a current_dungeon's room/level.
func switch_current_level(id: int):
	curr_level = curr_dungeon[id]


# Clears the current_level variable, for whatever use it can give in the future.
func remove_current_level():
	curr_level = null


# Adds a level to the current_dungeon given its id.
func add_level(level: Level, id: int):
	curr_dungeon[id] = level


# Removes a level to the current_dungeon given its id.
func remove_level(id: int):
	curr_dungeon.erase(id)


# Clears the current_dungeon dictionary.
func clear_levels() -> void:
	curr_dungeon.clear()


func move_player(player: Entity, level_id: int) -> void:
	## TODO - Maybe add a little transition animation, a fade in/out, blink
	
	## TODO - This will change plenty, teleport player to the new door's global_position
	## Plus saving, loading data maybe.
	curr_level.space.entities.remove_child(player)
	
	curr_level.visible = false
	curr_level.set_process(false)
	curr_level.set_physics_process(false)
	
	curr_level = curr_dungeon[level_id]
	curr_level.visible = true
	curr_level.set_process(true)
	curr_level.set_physics_process(true)
	
	curr_level.space.entities.add_child(player)
	player.global_position = curr_dungeon[level_id].space.start.global_position


func spawn(object: Node2D, spot: Node2D):
	if object.get_parent():
		print("Reparenting...")
		object.reparent(curr_level)
	else:
		print("Directly adding object to the level...")
		curr_level.add_child(object)
	object.global_position = spot.global_position


## WARN TODO - I can foresee issues when dealing with multiple levels.
## How to know in which one to spawn or add the child? Keep track of them...
## For this... Do children inherit the group(s) of the parent node? That'd fix all
