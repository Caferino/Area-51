extends Node

static func generate_dungeon(size: int) -> Node:
	print("CREATING DUNGEON...")
	var dungeon = Node2D.new()
	var id = 0
	
	## Hardcoded room 1, the starting room
	var room = load("res://Labs/Scenes/Dungeons/Dungeon Set 1/dungeon_room_1.tscn").instantiate()
	dungeon.add_child(room)
	room.global_position = Vector2(0,0)
	room.space.doors.get_child(0).goes_to = id + 1  ## WARN - THIS WILL CHANGE A LOT, META_DATA REQUIRED TO KNOW IF IT'S NWSE
	LevelManager.add_level(room, id)
	LevelManager.current_level(room)
	
	## Hardcoded room 2
	id += 1
	room = load("res://Labs/Scenes/Dungeons/Dungeon Set 1/dungeon_room_2.tscn").instantiate()
	dungeon.add_child(room)
	room.global_position = Vector2(2000,0)
	room.space.doors.get_child(0).goes_to = id - 1  ## WARN - THIS WILL CHANGE A LOT, META_DATA REQUIRED TO KNOW IF IT'S NWSE
	room.set_process(false)
	room.set_physics_process(false)
	room.visible = false
	LevelManager.add_level(room, id)
	
	return dungeon
