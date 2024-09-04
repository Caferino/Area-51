class_name Level extends Node2D

@export var time  : LevelTimeComponent  = null
@export var space : LevelSpaceComponent = null
@export var world : WorldEnvironment    = null

var time_stats: Dictionary = {  ## WARN - Might deprecate
	#GameEnums.LEVEL_STAT.INTERVAL : 0.6,
}

var environment_stats: Dictionary = {}

var weather_stats: Dictionary = {}


## NOTE - Each field should have its own long-time timer, which, at the end, it should trigger
## a growth cycle in a random set of plants within it. It should also have a 'priority queue'
## for plants that were watered or fertilized, to forcefully grow (maybe way quicker too, somehow?)


#func _ready() -> void:
	#time.interval = time_stats[GameEnums.LEVEL_STAT.INTERVAL]
	#time.tick.connect(_on_tick)
	#time.start()
#
#
#func _on_tick():
	### If you want the level to control when the Time Ticker restarts, stop it first.
	#game_loop()
#
#
#func game_loop():
	#pass
