extends VideoStreamPlayer

@onready var btn = $"../Pause"


func _on_pause_button_down():
	paused = !paused
	if paused:
		btn.text = "Play"
	else:
		btn.text = "Pause"


func _on_loop_button_down():
	loop = !loop
