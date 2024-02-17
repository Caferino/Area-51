extends Timer


func _ready():
	autostart = true
	start(2)


func _on_timeout():
	#start(randf_range(1, 3))
	start(randi_range(2, 4))
