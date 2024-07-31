class_name LevelTimeComponent extends Node

signal tick
var interval : float = 0.0


func start() -> void:
	$Timer.start(interval)


func _on_timer_timeout() -> void:
	$Timer.start(interval)
	tick.emit()
