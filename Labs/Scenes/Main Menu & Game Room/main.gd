class_name AlcarodianDungeons extends Node2D
## The Beginning of All.

## This will be hardcoded for now, to test the LevelManager/dungeon generator.
## Later, in the future, link this to a "Start Button" or something like that.

## Play = Loads last played run/dungeon, that is like a Load Game, load the rooms in
## the temp_root, if the player died or is new, is like a New Game, generate a dungeon.
func _ready() -> void:
	LevelManager.set_main_dungeon(self)
	# Imagine I pressed Play or New Game, hardcode it for now:
	var size := 10
	DungeonGenerator.generate_dungeon(size)
	
	var start_room = ResourceLoader.load("res://Labs/Scenes/Dungeons/Temp Run/0.tscn").instantiate()
	for door in start_room.space.doors.get_children():
		print("START ROOM DOOR ID = ", door.id)
	LevelManager.main_dungeon.add_child(start_room)
	LevelManager.current_level(start_room)
	
	var player = Caferino.spawn_player()
	LevelManager.curr_level.space.entities.add_child(player)
	player.global_position = LevelManager.curr_level.space.start.global_position
