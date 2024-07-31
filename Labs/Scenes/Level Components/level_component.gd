class_name Level extends Node2D

@export var space : LevelSpaceComponent = null
@export var time  : LevelTimeComponent  = null


var stats : Dictionary = {
	"time" : {
		"interval" = 6.0,  # Also known as "tick_interval"
		"cycle"    = 0.0
	},
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
	time.interval = stats["time"]["interval"]
	time.tick.connect(_on_tick)
	time.start()


func _on_tick():
	## If you want the level to control when the Time Ticker restarts, stop it first.
	game_loop()


func game_loop():
	## Each level must have its own game_loop if it has a unique logic.
	## Just DRY if a lot of levels share the same logic. Create a class for them, "Outside"...
	
	## IMPORTANT WARN - ! Make sure to animate only fields inside viewport/area around and in viewport
	## to reduce lag significantly in the future for the open world design. Start learning it here too,
	## in case you want massive caves or something. Learn advanced skills, this is what all this is for.
	
	## NOTE - What if every tick, here, I generate a RNG that defines everything?
	## WARN - Could that make this RNG predictable sometimes? Maybe generate it when calling each space's node
	
	## Do something to space continuum
	print("Level's GameLoop!")
	
	
