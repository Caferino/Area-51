class_name TimerComponent extends Node
## The entity's [color=lightgray]timers.

## TODO - This component might seem useless, but with it I could manage multiple
## timers for one entity. It can (or has to) have one timer by default, otherwise,
## why even add this component?

var timers: Dictionary = {}  ## A dictionary for [class Timer]s.


func _ready():
	## Register the timers
	for timer in get_children():
		if timer is Timer:
			timers[timer.name] = timer 
