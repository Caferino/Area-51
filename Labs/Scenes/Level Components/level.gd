class_name Level extends Node2D
## A [color=white]level[/color], by [color=white]Alcarodia.

@export var space   : SpaceComponent       = null
@export var env     : EnvironmentComponent = null
@export var cuts    : CutscenesComponent   = null

var environment_stats: Dictionary = {}

var weather_stats: Dictionary = {
	### WIND ###
	GameEnums.WEATHER.WIND_STRENGTH:  0.0,  # check plant's tilt() strength
	GameEnums.WEATHER.WIND_DIRECTION: 0.0,  # degrees
	GameEnums.WEATHER.WIND_FREQUENCY: 0.0,  # %
	### RAIN ###
	GameEnums.WEATHER.RAIN_STRENGTH:  0.0,  # check plant's tilt() strength
	GameEnums.WEATHER.RAIN_DIRECTION: 0.0,  # degrees
	GameEnums.WEATHER.RAIN_FREQUENCY: 0.0,  # %
}


func _ready():
	LevelManager.add_level(self)








## NOTE - Each field should have its own long-time timer, which, at the end, it should trigger
## a growth cycle in a random set of plants within it. It should also have a 'priority queue'
## for plants that were watered or fertilized, to forcefully grow (maybe way quicker too, somehow?)

#var time_stats: Dictionary = {  ## WARN - Might deprecate
	##GameEnums.LEVEL_STAT.INTERVAL : 0.6,
#}

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
