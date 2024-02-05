extends Node3D

var chunk_scene = preload("res://Labs/Scenes/(OD) Mineclone Room/Chunk.tscn")

var load_radius = 2
@onready var chunks = $Chunks
@onready var Theo = $"Old Theo"

var load_thread = Thread.new()
var mutex = Mutex.new()

func _ready():
	for i in range(0, load_radius):
		for j in range(0, load_radius):
			var chunk = chunk_scene.instantiate()
			chunk.set_chunk_position(Vector2(i, j))
			chunks.add_child(chunk)
	
	load_thread.start(_thread_process, Thread.PRIORITY_NORMAL) # TODO Test High priority


func _thread_process():
	while(true):
		for c in chunks.get_children():
			var cx = c.chunk_position.x
			var cz = c.chunk_position.y
			
			var px = floor(Theo.position.x / Global.DIMENSION.x)
			var pz = floor(Theo.position.z / Global.DIMENSION.z)
			
			var new_x = posmod(cx - px + load_radius/2, load_radius) + px - load_radius/2
			var new_z = posmod(cz - pz + load_radius/2, load_radius) + pz - load_radius/2
			
			if new_x != cx or new_z != cz:
				c.set_chunk_position(Vector2(int(new_x), int(new_z)))
				c.generate()
				c.update()











