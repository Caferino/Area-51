extends Node2D

@onready var path = $Path2D
@onready var path_follow = $Path2D/PathFollow2D
var debug = false


# Follow the Path
func get_path_direction(pos):
	var offset = path.curve.get_closest_offset(pos)
	path_follow.progress = offset
	return path_follow.transform.x


# Chase the Player
func get_player_path_direction(pos):
	return pos.direction_to(get_node("Theo").position)

