extends CanvasModulate
## [Color=yellow]Day [Color=purple]Night [Color=white]Cycle

@export var camera : Node2D = null
@export var cycle : GradientTexture1D

var image   = Image.new()
var texture = ImageTexture.new()


func _ready():
	visible = true  ## Just so I can hide it in the Inspector and not have everything dark
	image = Image.create_empty(128, 2, false, Image.FORMAT_RGBAH)
	camera = Caferino.player.controller.camera_base.camera


func _process(_delta: float) -> void:
	## TODO WARN - Fix this get_parent... Maybe INGAME_TO... and time should be stats, like a human's
	## and probably accessible and updated in realtime in a lightweight way inside a dictionary
	## to access with StringNames declared in GameEnums for performance.
	var value = (sin(WorldTime.current_time - PI / 2) + 1.0) / 2.0
	self.color = cycle.gradient.sample(value)


func _physics_process(_delta):
	_update_texture()
	var t = Transform2D(0, Vector2())
	if camera != null:
		var canvas_transform = camera.get_canvas_transform()
		var top_left = -canvas_transform.origin / canvas_transform.get_scale() * camera.zoom.x
		t = Transform2D(0, top_left)
	material.set_shader_parameter("global_transform", t)
	material.set_shader_parameter("zoom", camera.zoom.x)


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
	
	material.set_shader_parameter("n_lights", lights.size())
	material.set_shader_parameter("light_data", texture)
