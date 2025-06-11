extends Node

var rng := RandomNumberGenerator.new()
var used_tiles = {}  
var directions := [
	Vector2i(0, -1),  # North
	Vector2i(-1, 0),  # West
	Vector2i(0, 1),   # South
	Vector2i(1, 0)    # East
]
var doors_to_create : Array = []
var branch_doors    : Array = []


## Generates a dungeon inside a 11x11 matrix given the size.
func generate_dungeon(size: int) -> Node:
	if size < 5:     size = 5  # Hard cap the minimum size ("Easy")
	elif size > 60: size = 60  # Hard cap the maximum size ("Hard")
	
	var dungeon = Node2D.new()
	used_tiles.clear()
	var dims : Array = [                  ## 11 x 11 Matrix "Dimensions"
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	]
	var dims_doors : Array = [  ## Used to know what doors each room has (NWSE)
		[ [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0] ],
		[ [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0] ],
		[ [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0] ],
		[ [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0] ],
		[ [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0] ],
		[ [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0] ],
		[ [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0] ],
		[ [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0] ],
		[ [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0] ],
		[ [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0] ],
		[ [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0] ]
	]
	
	rng.randomize() # or set rng.seed = YOUR_SEED
	
	# 1) Pick start
	var start := Vector2i(5, 5)  # In the center, it will never create small dungeons
	used_tiles[start] = true
	dims[start.x][start.y] = 1  # Start
	
	var path = [start]
	var current = start
	
	doors_to_create = []
	doors_to_create.append(start)
	
	# 2) Build main path
	while path.size() < size:
		var valid_dirs := []
		for dir in directions:
			var next = current + dir
			if is_in_bounds(dims, next.x, next.y) and dims[next.x][next.y] == 0:
				valid_dirs.append(next)
		
		if valid_dirs.size() == 0:
			break  # no moves left, path is stuck
		
		current = valid_dirs[rng.randi_range(0, valid_dirs.size() - 1)]
		used_tiles[current] = true
		#print("CURRENT = ", current)
		dims[current.x][current.y] = 2  # Path
		doors_to_create.append(current)
		path.append(current)
	
	# 3) Mark the last cell as the Boss room
	var boss_pos = path[path.size() - 1]
	dims[boss_pos.x][boss_pos.y] = 3  # Boss
	
	# 4) Add random branches
	for tile in used_tiles.keys():
		if tile == boss_pos:
			continue  # No branches on the boss
		maybe_branch(dims, tile, 3)  # A depth of 3 limits 2 branches per branch
		maybe_branch(dims, tile, 3)  # Two+ calls of this function allows for the possibility of 4-door rooms
	
	fill_doors_data(dims_doors)
	generate_rooms(dungeon, dims_doors)
	
	_debug_print(dims, dims_doors)  ## DEBUG
	
	# Clean memory
	used_tiles = {}
	doors_to_create = []
	branch_doors = []
	
	return dungeon


## Recursive method to create branching rooms, dead ends.
func maybe_branch(dims: Array, origin: Vector2i, depth: int, identifier: int = 4):
	if depth <= 0:
		return
	
	if rng.randi_range(0, 100) > 50:  # 50% chance to grow a branch
		return
	
	var branch_length = rng.randi_range(1, 3)
	var dir = Vector2i(1, 0)
	var current = origin + dir
	for i in range(directions.size()):
		if used_tiles.has(current):
			dir = directions[i]
			current = origin + dir
		else:
			break
	var last_valid_tile = origin
	
	for i in range(branch_length):
		if not is_in_bounds(dims, current.x, current.y) or used_tiles.has(current):
			return
		dims[current.x][current.y] = identifier  # Branch marker
		branch_doors.append(last_valid_tile)  # I know they appear to repeat, but don't change that
		branch_doors.append(current)
		used_tiles[current] = true
		last_valid_tile = current
		current += directions[rng.randi_range(0, directions.size() - 1)]
	
	# Try to branch from the tip again
	maybe_branch(dims, last_valid_tile, depth - 1, identifier + 1)
	maybe_branch(dims, last_valid_tile, depth - 1, identifier + 1) # For double tips


## Checks whether the given coordinates is inside the matrix dims.
func is_in_bounds(dims: Array, x: int, y: int) -> bool:
	return x >= 0 and x < dims.size() and y >= 0 and y < dims[0].size()


## This function fills dims_doors with the data filled in vars doors_to_create and branch_doors
## WARN - doors_to_create is Stride-1 Pairing, while branch_doors is Stride-2 Pairing. E.g.:
## doors_to_create will grab index 0, 1, then 1, 2, then 2, 3, then 3, 4 then 4, 5....
## branch_doors will grab index 0, 1, then 2, 3, then 4, 5, then 6, 7, then 8, 9...
func fill_doors_data(dims_doors):
	var mapping = {
		Vector2i(0, -1): 0,  # North
		Vector2i(-1, 0): 1,  # West
		Vector2i(0, 1): 2,   # South
		Vector2i(1, 0): 3    # East
	}
	
	## doors_to_create - Stride-1 Pairing
	for i in range(doors_to_create.size() - 1):
		var from = doors_to_create[i]
		var to = doors_to_create[i + 1]
		assign_door(from, to, dims_doors, mapping)
		assign_door(to, from, dims_doors, mapping)
	
	
	## branch_doors - Stride-2 Pairing
	for i in range(0, branch_doors.size() - 1, 2):
		var from = branch_doors[i]
		var to = branch_doors[i + 1]
		assign_door(from, to, dims_doors, mapping)
		assign_door(to, from, dims_doors, mapping)


func assign_door(from: Vector2i, to: Vector2i, dims_doors: Array, mapping: Dictionary):
	var dir := Vector2i(to.y - from.y, from.x - to.x)
	dir.y = -dir.y  # Inverting y is needed for correct North/South results
	var index = mapping[dir]
	var letters = ["N", "W", "S", "E"]
	dims_doors[from.x][from.y][index] = letters[index]


## This function adds the physical dungeons based on the doors needed according to dims_doors.
## To save performance, only the dungeon the player is inside will be visible and running its
## process and physics_process methods.
func generate_rooms(dungeon, dims_rooms):
	pass


func _debug_print(dims, dims_doors):
	print(doors_to_create)
	print(branch_doors)
	
	for row in dims:
		print(row)
	
	for row in dims_doors:
		print(row)





	## Hardcoded room 1, the starting room
	#var room = load("res://Labs/Scenes/Dungeons/Dungeon Set 1/dungeon_room_1.tscn").instantiate()
	#dungeon.add_child(room)
	#room.global_position = Vector2(0,0)
	#room.space.doors.get_child(0).goes_to = id + 1  ## WARN - THIS WILL CHANGE A LOT, META_DATA REQUIRED TO KNOW IF IT'S NWSE
	#LevelManager.add_level(room, id)
	#LevelManager.current_level(room)
	#
	### Hardcoded room 2
	#id += 1
	#room = load("res://Labs/Scenes/Dungeons/Dungeon Set 1/dungeon_room_2.tscn").instantiate()
	#dungeon.add_child(room)
	#room.global_position = Vector2(2000,0)
	#room.space.doors.get_child(0).goes_to = id - 1  ## WARN - THIS WILL CHANGE A LOT, META_DATA REQUIRED TO KNOW IF IT'S NWSE
	#room.set_process(false)
	#room.set_physics_process(false)
	#room.visible = false
	#LevelManager.add_level(room, id)
