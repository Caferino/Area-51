class_name Camera extends Node2D
## The alcarodian camera.
## @experimental
## TODO - Remaster this. Too many variables, probably unecessary Node2D parent, etc.

@onready var origin     : Marker2D         = $Origin                ## The camera's origin.
@onready var camera     : Camera2D         = $Camera                ## The [Camera2D] object.
@onready var drag_area  : CollisionShape2D = $"View Distance/Area"  ## The [Area2D] to move in.
@onready var tween      : Tween            = create_tween()         ## Animates the camera's movement.

var drag_speed          : float     = 0.5                               ## The speed for the view-dragging.
var prev_mouse_position : Vector2   = Vector2(0, 0)                     ## Previous mouse location.
var zoom_speed          : Vector2   = Vector2(1, 1)                     ## Zoom in/out speed.
var drag_bounds         : Rect2     = Rect2(-1000, -1000, 2000, 2000)   ## Bounds for the view-dragging.

# For the camera's breathing effect
var min_x        : float  = -3.0                       ## Minimum x coordinate it will touch.
var max_x        : float  =  3.0                       ## Maximum x coordinate it will touch.
var min_y        : float  = -3.0                       ## Minimum y coordinate it will touch.
var max_y        : float  =  3.0                       ## Maximum y coordinate it will touch.
var breathing_in : bool   = false                      ## Saves the current "breathing" state.
var random_x     : float  = randf_range(min_x, max_x)  ## Random x coordinate for the bounce.
var random_y     : float  = randf_range(0, max_y)      ## Random y coordinate for the bounce.


## Prepares the variables [member Camera.prev_mouse_position] and [member Camera.tween].
func _ready():
	prev_mouse_position = origin.global_position
	tween.connect("finished", breath)
	hold_camera()


## Reads the zoom-in/out input from the player for an "aiming bow" animation in first-person 3D.
func _input(_event: InputEvent):
	if Input.is_action_pressed("zoom_in"):
		camera.zoom = clamp(camera.zoom + zoom_speed, Vector2(2, 2), Vector2(10,10))
	if Input.is_action_pressed("zoom_out"):
		camera.zoom = clamp(camera.zoom - zoom_speed, Vector2(2, 2), Vector2(10,10))
	
	if Input.is_action_pressed("drag_camera"):
		tween.pause()
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CONFINED_HIDDEN:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

		# Update camera position based on mouse movement
		var current_mouse_position = get_global_mouse_position()
		var delta = (current_mouse_position - prev_mouse_position) * drag_speed
		camera.global_position += delta

		# Clamp camera position within bounds
		#camera.global_position.x = clamp(camera.global_position.x, drag_area.get_shape().size.x, drag_area.get_shape().size.x - camera.get_viewport_rect().size.x)
		#camera.global_position.y = clamp(camera.global_position.y, drag_area.get_shape().size.y, drag_area.get_shape().size.y - camera.get_viewport_rect().size.y)

		prev_mouse_position = current_mouse_position

	elif Input.is_action_just_released("drag_camera"):
		tween.play()
		# Reset mouse position and camera position
		prev_mouse_position = origin.global_position
		camera.global_position = origin.global_position
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


## Simulates a handheld effect by using tweens.
func hold_camera():
	tween.stop()
	tween.tween_property(camera, "position", Vector2(random_x, random_y), 6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD).set_delay(randf_range(0.001, 0.2))
	tween.play()


## Complimentary method for the handheld effect.
## Bounces the camera up and down within a space and a short pause.
func breath():
	if breathing_in:
		random_x = randf_range(min_x, max_x)
		random_y = randf_range(min_y, 0)
		breathing_in = !breathing_in
	else:
		random_x = randf_range(min_x, max_x)
		random_y = randf_range(0, max_y)
		breathing_in = !breathing_in
	hold_camera()
