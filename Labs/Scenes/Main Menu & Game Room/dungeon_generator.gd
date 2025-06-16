extends Node

var directions = {
	Vector2i(0, -1): 0,  # North
	Vector2i(-1, 0): 1,  # West
	Vector2i(0, 1): 2,   # South
	Vector2i(1, 0): 3    # East
}
var rng := RandomNumberGenerator.new()
var used_tiles : Dictionary = {}  # NOTE - Can't be Array; .has() is hashed. Vector2i(5, 5) != Vector2i(5, 5) unless they’re the same object.
var doors_to_create : Array = []
var branch_doors    : Array = []
var id : int = 0


## Generates a dungeon inside a 11x11 matrix given the size.
func generate_dungeon(size: int) -> void:
	if size < 5:     size = 5  # Hard cap the minimum size ("Easy")
	elif size > 60: size = 60  # Hard cap the maximum size ("Hard")
	
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
	var directions_keys = directions.keys()
	
	rng.randomize() # or set rng.seed = YOUR_SEED
	
	# 1) Pick start
	id = 0
	var start := Vector2i(5, 5)  # In the center, it will never create small dungeons
	used_tiles[start] = id
	id += 1
	dims[start.x][start.y] = 1  # Start
	
	var path = [start]
	var current = start
	
	doors_to_create = []
	doors_to_create.append(start)
	
	# 2) Build main path
	while path.size() < size:
		var valid_dirs := []
		for dir in directions_keys:
			var next = current + dir
			if is_in_bounds(dims, next.x, next.y) and dims[next.x][next.y] == 0:
				valid_dirs.append(next)
		
		if valid_dirs.size() == 0:
			break  # no moves left, path is stuck
		
		current = valid_dirs[rng.randi_range(0, valid_dirs.size() - 1)]
		used_tiles[current] = id
		id += 1
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
	generate_rooms(dims_doors)
	
	_debug_print(dims, dims_doors)  ## DEBUG
	
	# Clean memory
	used_tiles = {}
	doors_to_create = []
	branch_doors = []


## Recursive method to create branching rooms, dead ends.
func maybe_branch(dims: Array, origin: Vector2i, depth: int, identifier: int = 4):
	if depth <= 0:
		return
	
	if rng.randi_range(0, 100) > 50:  # 50% chance to grow a branch
		return
	
	var directions_keys = directions.keys()
	var branch_length = rng.randi_range(1, 3)
	var dir = Vector2i(1, 0)
	var current = origin + dir
	for i in range(directions_keys.size()):
		if used_tiles.has(current):
			dir = directions_keys[i]
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
		used_tiles[current] = id
		id += 1
		last_valid_tile = current
		current += directions_keys[rng.randi_range(0, directions_keys.size() - 1)]
	
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
func fill_doors_data(dims_doors: Array):
	var index : int = 0
	var dir : Vector2i = Vector2i(0, 0)
	var letters = ["N", "W", "S", "E"]
	
	## 1) doors_to_create - Stride-1 Pairing
	for i in range(doors_to_create.size() - 1):
		var from = doors_to_create[i]
		var to = doors_to_create[i + 1]
		dir = get_door_dir(from, to)
		index = directions[dir]
		dims_doors[from.x][from.y][index] = letters[index]
		dir = get_door_dir(to, from)
		index = directions[dir]
		dims_doors[to.x][to.y][index] = letters[index]
	
	
	## 2) branch_doors - Stride-2 Pairing
	for i in range(0, branch_doors.size() - 1, 2):
		var from = branch_doors[i]
		var to = branch_doors[i + 1]
		dir = get_door_dir(from, to)
		index = directions[dir]
		dims_doors[from.x][from.y][index] = letters[index]
		dir = get_door_dir(to, from)
		index = directions[dir]
		dims_doors[to.x][to.y][index] = letters[index]


## This function adds the physical dungeons based on the doors needed according to dims_doors.
## To save performance, only the dungeon the player is inside will be visible and running its
## process and physics_process methods.
func generate_rooms(dims_doors: Array):
	## 1) Start the global_position of the dungeon & created_rooms
	var created_rooms : Dictionary = {} # Has to be a Dictionary for using .has() with Vector2is
	
	## 2) Generates the dungeon rooms per tile in in used_tiles
	for i in used_tiles.size():
		## 2-1) Get the current tile
		var tile : Vector2i = used_tiles.find_key(i)
		
		## 2-2) Get the doors needed for this room
		var doors : String = ""
		for val in dims_doors[tile.x][tile.y]:
			if typeof(val) == TYPE_STRING:
				doors += val
		
		## 2-3) Grab a random dungeon room from its pool & save it
		var rooms_count = DirAccess.get_files_at("res://Labs/Scenes/Dungeons/Pools/" + doors).size()
		var random_index = randi() % rooms_count + 1
		var room = load("res://Labs/Scenes/Dungeons/Pools/" + doors + "/dungeon_room_" + str(random_index) + ".tscn").instantiate()
		for door in room.space.doors.get_children():
			door.id = i
		created_rooms[used_tiles.find_key(i)] = room
	
	
	## 3) Connecting the doors
	var dir : Vector2i = Vector2i(0, 0)
	var letters = ["N", "W", "S", "E"]
	var letter_from : String = ""
	var letter_to : String = ""
	
	var from : Vector2i = Vector2i(0, 0)
	var to : Vector2i = Vector2i(0, 0)
	var from_room : Node2D
	var to_room : Node2D
	var from_spawner : Marker2D
	var to_spawner : Marker2D
	var from_room_door : Area2D
	var to_room_door : Area2D
	## doors_to_create - Stride-1 Pairing
	for i in range(doors_to_create.size() - 1):
		from = doors_to_create[i]
		to = doors_to_create[i + 1]
		from_room = created_rooms[doors_to_create[i]]
		to_room = created_rooms[doors_to_create[i + 1]]
		
		# From Room
		dir = get_door_dir(from, to)
		letter_from = letters[directions[dir]]
		from_spawner = from_room.space.spawners.get_node(letter_from)
		from_room_door = from_room.space.doors.get_node(letter_from)
		
		# To Room
		dir = get_door_dir(to, from)
		letter_to = letters[directions[dir]]
		to_spawner = to_room.space.spawners.get_node(letter_to)
		to_room_door = to_room.space.doors.get_node(letter_to)
		
		# Connecting From -> To and To -> From
		from_room_door.id = used_tiles[to]
		to_room_door.id = used_tiles[from]
		print("ID FROM ", from_room_door.id, " TO ", to_room_door.id)
		from_room_door.goes_to = to_spawner.global_position# + to_room.global_position
		to_room_door.goes_to = from_spawner.global_position# + from_room.global_position
	
	
	## branch_doors - Stride-2 Pairing
	for i in range(0, branch_doors.size() - 1, 2):
		from = branch_doors[i]
		to = branch_doors[i + 1]
		from_room = created_rooms[branch_doors[i]]
		to_room = created_rooms[branch_doors[i + 1]]
		
		# From Room
		dir = get_door_dir(from, to)
		letter_from = letters[directions[dir]]
		from_spawner = from_room.space.spawners.get_node(letter_from)
		from_room_door = from_room.space.doors.get_node(letter_from)
		
		# To Room
		dir = get_door_dir(to, from)
		letter_to = letters[directions[dir]]
		to_spawner = to_room.space.spawners.get_node(letter_to)
		to_room_door = to_room.space.doors.get_node(letter_to)
		
		# Connecting From -> To and To -> From
		from_room_door.id = used_tiles[to]
		to_room_door.id = used_tiles[from]
		from_room_door.goes_to = to_spawner.global_position# + to_room.global_position
		to_room_door.goes_to = from_spawner.global_position# + from_room.global_position
	
	
	save_rooms(created_rooms)
	## TODO - RUN PACK_ROOMS HERE, BEFORE VAR created_rooms GETS CLEANED AND ITS ROOMS ERASED!


func save_rooms(created_rooms: Dictionary):
	var packed_room = PackedScene.new()  ## TODO - MAYBE MOVE THIS LAST, A PACK_ROOMS FUNCTION
	for i in created_rooms.size():
		var room = created_rooms[used_tiles.find_key(i)]
		for door in room.space.doors.get_children():
			print("START ROOM DOOR ID = ", door.id)
		if packed_room.pack(room) == OK:
			var err = ResourceSaver.save(packed_room, "res://Labs/Scenes/Dungeons/Temp Run/" + str(i) + ".tscn")
			if err != OK:
				print("Failed to save scene ", str(i), ".tscn", " with error code: ", err)
		else:
			print("Failed to pack the room ", str(i), ".tscn")


func get_door_dir(from: Vector2i, to: Vector2i) -> Vector2i:
	return Vector2i(to.y - from.y, -(from.x - to.x)) # Inverting y is needed for correct North/South results


func _debug_print(dims, dims_doors):
	print("Doors to Create:")
	print(doors_to_create)
	print("Branch Doors:")
	print(branch_doors)
	
	print("Dims:")
	for row in dims:
		print(row)
	
	print("Dims Doors:")
	for row in dims_doors:
		print(row)
