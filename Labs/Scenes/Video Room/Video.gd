extends VideoStreamPlayer


func _ready():
	%Video.paused = true
	%Play.text = "Play"
	%Video.loop = false
	%Loop.text = "Loop"

func _on_pause_button_down():
	if paused == true:
		%Play.text = "Pause"
		paused = !paused
	else:
		%Play.text = "Play"
		paused = !paused


func _on_loop_button_down():
	if loop == true:
		%Loop.text = "Loop"
		loop = !loop
	else:
		%Loop.text = "Looping"
		loop = !loop
