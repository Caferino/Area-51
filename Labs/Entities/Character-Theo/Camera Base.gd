extends Node2D

@onready var origin = $Origin
@onready var camera = $Camera
@onready var drag_area = $"View Distance/Area"
var drag_speed = 0.5
var zoom_speed = Vector2(1, 1)
var drag_bounds = Rect2(-1000, -1000, 2000, 2000)

# For the camera's breathing effect
var min_x = -3
var max_x = 3
var min_y = -3
var max_y = 3
var breathing_in = false
var random_x = randf_range(min_x, max_x)
var random_y = randf_range(0, max_y)
@onready var tween = create_tween()


var prev_mouse_position

func _ready():
	prev_mouse_position = origin.global_position
	tween.connect("finished", breath)
	hold_camera()

func _input(_event):
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


func hold_camera():
	tween.stop()
	tween.tween_property(camera, "position", Vector2(random_x, random_y), 6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD).set_delay(randf_range(0.001, 0.2))
	tween.play()

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

