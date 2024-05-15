extends Node


func random_point_around(ring_radius: Vector2):
	if ring_radius.x > ring_radius.y:
		var x = ring_radius.x
		ring_radius.x = ring_radius.y
		ring_radius.y = x
	
	var angle = randf_range(0, PI * 2)
	var distance = randf_range(ring_radius.x, ring_radius.y)
	var direction = Vector2(sin(angle), cos(angle))
	
	return direction * distance
