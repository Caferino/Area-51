class_name LevelComponent extends Node2D

@export var space : LevelSpaceComponent = null
@export var time  : LevelTimeComponent  = null


var stats : Dictionary = {
	"time_cycle" : {},
	"environment" : {},
	"weather" : {},
	"wind" : {}
}

## WARN - ! What if I cancel all these components and instead turn them into stats
## every level must have, like entities do with speed, movement_speed, etc...
## this way, I avoid having the overhead and O(8~) loop... 

## WARN - Should this manage the ticks? Based on time, and effect on Space
## WARN - I feel like TimeComponent should have the ticket, and LevelComponent by itself
## should not exist ever, it gets renamed with the actual level's name and that's it?

## How often is a tick or what? How does runescape or other games do this?

## WARN - Every level has a TimeComponent (Node) and a SpaceComponent (Node2D)
## EVerything I just said below, put it in SpaceComponent maybe, all the Weather, Wind, etc go there
## LevelComponent should only have Time and Space, that's it.


## TODO - Add a verify check of what components this level has, avoid dead conditions, or excessive


func _ready() -> void:
	## TODO - Should I register all of Space's nodes here and then do stuff to them every tick?
	time.tick_timeout.connect(_on_tick_timeout)


func _on_tick_timeout():
	print("Tick!")
	## TODO - Juicy logic here
