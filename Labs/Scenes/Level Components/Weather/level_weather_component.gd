class_name WeatherComponent extends Node2D
## Manages weather phenomenas.

@export var rain_component : RainComponent  = null
@export var wind_component : WindComponent  = null
@export var dayn_component : CanvasModulate = null  ## Day-Night Component

## TODO - In case I add a UI for Day/Night, or morning sounds, ambience...
## Here would go the setup. Deprecate the cgiven layout, it's from:
## https://youtu.be/HjwWe-V3nHs   I don't need to copy it 1:1
#func _ready():
	#canvas_layer.visible = true
	#SignalManager.time_tick.conenct(ui.set_daytime)
	#SignalManager.time_tick.conenct(sound_machine.set_daytime)



# NOTE - Season dictates general stats? Temperature, Precipitation... 

#var season        : String = ''
#var temperature   : float  = 0.0  # Cº or Fº?
#var precipitation : float  = 0.0
#var rain_chance   : float  = 0.0
