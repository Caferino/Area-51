class_name Wind extends Area2D


func blow() -> void:
	print("Wind blows!")
	pass


func _on_timer_timeout() -> void:
	blow()
