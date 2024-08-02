extends Node2D

var debug = false


# Chase the Player
func get_player_path_direction(pos):
	return pos.direction_to(get_node("Smoke Ashburn").position)
