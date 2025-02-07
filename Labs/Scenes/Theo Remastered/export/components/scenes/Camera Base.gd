class_name CameraBase extends Node2D
## The alcarodian [color=cyan]camera.

@onready var tween      : Tween    = create_tween()             ## Animates the camera's movement.
@export  var controller : PlayerControllerComponent             ## The attached [PlayerControllerComponent].
@export  var camera     : Camera2D                              ## The attached [Camera2D].

const zoom_speed        : Vector2  = Vector2(0.5, 0.5)              ## Zoom in/out speed.
const drag_dist         : float    = 500.0                      ## The camera's dragging distance allowed.
var dragging_cam        : bool     = false                      ## Is the camera currently being dragged?
# For the camera's breathing effect
var min_x               : float    =  -3.0                      ## Minimum x coordinate it will touch.
var max_x               : float    =   3.0                      ## Maximum x coordinate it will touch.
var min_y               : float    =  -3.0                      ## Minimum y coordinate it will touch.
var max_y               : float    =   3.0                      ## Maximum y coordinate it will touch.
var hold_speed          : float    =   6.0                      ## Speed for the [PropertyTweener].
var breathing_in        : bool     = false                      ## Saves the current "breathing" state.
var random_x            : float    = randf_range(min_x, max_x)  ## Random x coordinate for the bounce.
var random_y            : float    = randf_range(0, max_y)      ## Random y coordinate for the bounce.


## Starts by holding the camera.
func _ready():
	hold_camera()


## Reads the given zoom-in/out input from the player and whether the screen is being dragged.
func _input(_event: InputEvent):
	if Input.is_action_pressed("zoom_in"):
		camera.zoom = clamp(camera.zoom + zoom_speed, Vector2(2, 2), Vector2(9,9))
	if Input.is_action_pressed("zoom_out"):
		camera.zoom = clamp(camera.zoom - zoom_speed, Vector2(2, 2), Vector2(9,9))
	if Input.is_action_pressed("drag_camera"):
		start_dragging()
	elif Input.is_action_just_released("drag_camera"):
		stop_dragging()


## Begins to follow the mouse inside a certain distance ([member CameraBase.drag_dist]).
func start_dragging():
	if !controller.moving:
		if !dragging_cam:
			Input.set_custom_mouse_cursor(load("res://Labs/Assets/X. Other/Cursor/dragging.svg"))
		
		dragging_cam = true
		
		tween.kill()
		
		## TODO - In the future, test this feature with different screen sizes. Might hurt.
		if get_parent().global_position.distance_to(get_global_mouse_position()) <= drag_dist:
			global_position = get_global_mouse_position()
			breath()
		else:
			var direction = get_parent().global_position.direction_to(get_global_mouse_position())
			position = clamp(direction * drag_dist, Vector2(-drag_dist, -drag_dist), Vector2(drag_dist, drag_dist))
			breath()


## Stops the camera dragging, returning it to its controller's global position instantly.
func stop_dragging():
	Input.set_custom_mouse_cursor(load("res://Labs/Assets/X. Other/Cursor/dot.svg"))
	global_position = controller.global_position
	dragging_cam = false
	hold_camera()


## Simulates a handheld effect by using tweens.
func hold_camera():
	# NOTE - Must kill and create_tween everytime, or we get Orphan Tweeners overtime
	tween.kill()
	tween = create_tween()
	tween.connect("finished", breath)
	tween.tween_property(camera, "position", Vector2(random_x, random_y), hold_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD).set_delay(randf_range(0.001, 0.2))
	tween.play()


## Complimentary method for the handheld effect.
## Bounces the camera up and down within a space and a short pause.
## Runs everytime the tween finishes its animation.
func breath():
	random_x = randf_range(min_x, max_x)
	if breathing_in : random_y = randf_range(min_y, 0)
	else            : random_y = randf_range(0, max_y)
	breathing_in = !breathing_in
	hold_camera()


## Increases or reduces the breathing effect's min and max values to control the shaking.
func modify_breath(nmin_x: float, nmax_x: float, nmin_y: float, nmax_y: float, nhold_speed: float):
	min_x      =  nmin_x
	max_x      =  nmax_x
	min_y      =  nmin_y
	max_y      =  nmax_y
	hold_speed =  nhold_speed
	breath()


## Resets the breathing effect's min and max back to normal.
func reset_breath():
	min_x      = -3.0
	max_x      =  3.0
	min_y      = -3.0
	max_y      =  3.0
	hold_speed =  6.0
