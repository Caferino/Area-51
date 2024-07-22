class_name LevelTimeComponent extends Node

signal tick_timeout

## TODO - Make this dynamic someday, to use in a lot of different things, not just the weather system.
var tick_interval : float = 6.0  ## The amount of time to wait before running the level's game loop.


func _ready() -> void:
	$Ticker.start(tick_interval)


func _on_ticker_timeout() -> void:
	tick_timeout.emit()
	$Ticker.start(tick_interval)




## WARN - Maybe these should go in a "World" script, global one, not per level...
#var time  : float = 0.0  # Hour format? hh:mm:ss:ms?
#var day   : int   = 1
#var month : int   = 1


