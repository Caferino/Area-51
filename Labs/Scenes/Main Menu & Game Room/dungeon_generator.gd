extends Node

static func generate_dungeon(size: int) -> Node:
	if size < 3:     size = 3
	elif size > 100: size = 100
	var dungeon = Node2D.new()
	var dims : Array = [                  ## 10 x 10 Matrix "Dimensions"
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	]
	var start : Vector2i = Vector2i(randi_range(0, 9), randi_range(0, 9))
	dims[start.x][start.y] = "S"
	
	for id in range(10):
		print(dims[id])
	
	
	for id in size:
		print(id)
	
	
	return dungeon
