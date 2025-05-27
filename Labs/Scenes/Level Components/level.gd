class_name Level extends Node2D
## A [color=white]level[/color], by [color=white]Alcarodia.

@export var space   : SpaceComponent       = null
@export var cuts    : CutscenesComponent   = null
@export var env     : EnvironmentComponent = null

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
	SignalManager.check_tile_type.connect(check_tile_type)


func check_tile_type(position: Vector2i, controller: EntityController):
	# WARN NOTE - Order matters, floor should always be last.
	var tilemaps = [space.tilemaps.decor, space.tilemaps.floor]
	
	for tilemap in tilemaps:
		var cell_pos = tilemap.local_to_map(position)
		var data = tilemap.get_cell_tile_data(cell_pos)
		
		if data != null:
			var tile_type = data.get_custom_data("tile_type")
			if tile_type != 0 or tilemap == space.tilemaps.floor:
				controller.swimming = false
				controller.sitting  = false
				
				if tile_type == 1:      ## SHALLOW_WATER
					# TODO - Water walk sound, NO swimming here
					pass
				elif tile_type == 2:    ## DEEP_WATER
					# TODO - Water swim sound
					controller.swimming = true
				elif tile_type == 3:    ## DIRT
					# TODO - Walking on dirt sound
					pass
				elif tile_type == 4:    ## GRASS
					# TODO - Walking on grass sound
					pass
				elif tile_type == 5:    ## CHAIR
					if !controller.rolling: # Rolling while sitting loops forever, this fixes that
						controller.sitting = true
						controller.anim_state = "Sit"
				return







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
