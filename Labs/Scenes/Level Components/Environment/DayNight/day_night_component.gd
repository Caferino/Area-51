class_name DayNightComponent extends Node2D
## [Color=yellow]Day [Color=purple]Night [Color=white]Cycle

## TODO - Control sunrays more granularly. Make them show only in the morning,
## not during all day and night (unless moonlight. Moon phases too, baby!)

@export var lighting : ColorRect = null
@export var sunrays  : ColorRect = null
@export var camera   : Node2D    = null   ## NOTE - Stay NULL. Grabs Caferino.gd's current player's camera in script.
@export var cycle    : GradientTexture1D = null
@onready var tween   : Tween = create_tween().set_parallel(true)  ## Animates the sun rays parameters.

var image   : Image   = Image.new()
var texture : Texture = ImageTexture.new()


func _ready():
	tween.kill()    ## Avoids a weird error where @onready tweens must be used quickly
	visible = true  ## Just so I can hide it in the Inspector and not have everything dark.
	SignalManager.time_tick.connect(handle_light)
	image = Image.create_empty(128, 2, false, Image.FORMAT_RGBAH)
	
	## WARN - Turned off, to avoid bugs. Enable this on a signal/player's arrival call, and leave too
	## Can also do this for every level the player visits.
	#camera = Caferino.player.controller.camera_base.camera
	set_process(false)
	set_physics_process(false)


## Updates the daylight
func _process(_delta: float) -> void:
	## NOTE - I replaced this with a lerp, then a tween thinking it'd smooth it,
	## but it didn't. At INGAME_SPEED = 1.0 and such it looks choppy, in all three.
	## It's innevitable, confirmed by other Game Devs, speed matters a lot for the sin wave.
	var value = (sin(WorldTime.current_time - PI / 2) + 1.0) / 2.0
	lighting.material.set_shader_parameter("dark_color", cycle.gradient.sample(value))


## If there are LightSources in the scene, this will reveal them in the darkness.
func _physics_process(_delta):
	_update_texture()
	var t = Transform2D(0, Vector2())
	if camera != null:
		var canvas_transform = camera.get_canvas_transform()
		var top_left = -canvas_transform.origin / canvas_transform.get_scale() * camera.zoom.x
		t = Transform2D(0, top_left)
	lighting.material.set_shader_parameter("global_transform", t)
	lighting.material.set_shader_parameter("zoom", camera.zoom.x)


func _update_texture():
	# Get all light sources in the level
	var lights = get_tree().get_nodes_in_group("lights")
	# Assign values to the texture
	for i in lights.size():
		var light = lights[i]
		if light is LightSource:
			# Store the x and y position in the red and green channels
			# How luminious the light is in the blue channel
			# And the light's radius in the alpha channel
			var light_position = light.global_position.floor()
			image.set_pixel(i, 0, Color( light_position.x, light_position.y, light.strength, light.radius))
			# Store the light's color in the 2nd row
			image.set_pixel(i, 1, light.color)
	
	texture = ImageTexture.create_from_image(image)
	
	lighting.material.set_shader_parameter("n_lights", lights.size())
	lighting.material.set_shader_parameter("light_data", texture)


## Handles events like sun rays, moonlight, and more depending on the hour.
## NOTE - If INGAME_SPEED, the time's speed is too high, minutes will start
## to jump in increments of 2, 3, etc., and minute 0 is usually skipped.
## If I ever seek to control the speed and increase it for cutscenes or 
## weird time spells, taking the INGAME_SPEED into account here fixes that.
## TODO - Moon Phases can just affect the Night and Midnight's Color's Alpha value.
func handle_light(day: int, hour: int, minute: int) -> void:
	#print("Day: ", day, ", Hour: ", hour, ", Minute: ", minute)  # DEBUG
	if minute == 0:
		if hour == 6:     ## 6:00 A.M.  -  MORNING
			set_shader_params(Color(1.0, 0.9, 0.65, 0.8), 1.0, 0.1, 1.0, 0.22, 1.0, 0.16)
		elif hour == 9:   ## 9:00 A.M.  -  NOON
			set_shader_params(Color(1.0, 0.9, 0.65, 0.8), 0.1, 1.0, 0.22, 1.0, 0.16, 1.0)
		elif hour == 18:  ## 6:00 P.M.  -  NIGHT
			var moon_phase = get_moon_phase(day)
			set_shader_params(Color(1.0, 0.75, 1.0, moon_phase), 1.0, 0.1, 1.0, 0.22, 1.0, 0.16)
		elif hour == 5:   ## 5:00 A.M.  -  MIDNIGHT
			var moon_phase = get_moon_phase(day)
			set_shader_params(Color(1.0, 0.75, 1.0, moon_phase), 0.1, 1.0, 0.22, 1.0, 0.16, 1.0)


func set_shader_params(color: Color, iv_cutoff: float, cutoff: float, iv_falloff: float, falloff: float, iv_edge_fade: float, edge_fade: float) -> void:
	## Initial shader values
	sunrays.material.set_shader_parameter("color", color)  # No need to animate
	sunrays.material.set_shader_parameter("cutoff", iv_cutoff)
	sunrays.material.set_shader_parameter("falloff", iv_falloff)
	sunrays.material.set_shader_parameter("edge_fade", iv_edge_fade)
	
	## Interpolate and animate with a tweener to the desired value
	tween.kill()
	tween = create_tween().set_parallel(true)
	tween.tween_property(sunrays.material, "shader_parameter/cutoff", cutoff, 60 / WorldTime.INGAME_SPEED)
	tween.tween_property(sunrays.material, "shader_parameter/falloff", falloff, 60 / WorldTime.INGAME_SPEED)
	tween.tween_property(sunrays.material, "shader_parameter/edge_fade", edge_fade, 60 / WorldTime.INGAME_SPEED)
	tween.play()


func get_moon_phase(day: int):
	## Taken from: https://calculator.now/moon-phase-calculator/
	return (1 - cos((2 * PI * day) / 29.53)) * 50 / 100
