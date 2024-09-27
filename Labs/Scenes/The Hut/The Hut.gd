class_name TheHut extends Level
## Alcarodian Dungeons' main level.
## NOTE WARN - Might become "Outside" in the future / other games. 
## Give this the logic you'd give to anything outside, weather, time, rain chance...

## Maybe someday: Level extends Area ex Zone ex Country ex Kingdom ex Realm...

func _ready() -> void:
	### WEATHER COMPONENT ###
	### WIND ###
	weather_stats[GameEnums.WEATHER.WIND_STRENGTH]  = 0.0  #
	weather_stats[GameEnums.WEATHER.WIND_DIRECTION] = 0.0  # degrees
	weather_stats[GameEnums.WEATHER.WIND_FREQUENCY] = 0.0  # %
	### RAIN ###
	weather_stats[GameEnums.WEATHER.RAIN_STRENGTH]  = 0.0
	weather_stats[GameEnums.WEATHER.RAIN_DIRECTION] = 0.0
	weather_stats[GameEnums.WEATHER.RAIN_FREQUENCY] = 0.0


#
#func game_loop():  ## WARN - Deprecate maybe, no use for it yet now, comment it
	### Each level must have its own game_loop if it has a unique logic.
	### Just DRY if a lot of levels share the same logic. Create a class for them, "Outside"...
	#
	### IMPORTANT WARN - ! Make sure to animate only fields inside viewport/area around and in viewport
	### to reduce lag significantly in the future for the open world design. Start learning it here too,
	### in case you want massive caves or something. Learn advanced skills, this is what all this is for.
	#
	### NOTE - What if every tick, here, I generate a RNG that defines everything?
	### WARN - Could that make this RNG predictable sometimes? Maybe generate it when calling each space's node
	#
	## Do stuff here
	#
	### WARN - IMPORTANT: What if I use timers instead? With random times based on stats
	### I'd add them dynamically per what level needs or uses (wind used by The Hut but not caves),
	### create and connect them in ready based on what the level needs... Avoid this endless loop
	### BUT, what if the player exits and enters The Hut quickly? The rain/current event would reset?
	#
	#rng = randf()
	#
	#if rng < 0.75:
		#print("75% chance event!")
