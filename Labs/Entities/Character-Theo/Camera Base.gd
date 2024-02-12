extends Node2D

@onready var origin = $Origin
@onready var camera = $Camera
var drag_speed = 0.5
var zoom_speed = Vector2(1, 1)

var prev_mouse_position

func _ready():
	prev_mouse_position = get_global_mouse_position()

func _input(event):
	if Input.is_action_pressed("zoom_in"):
		camera.zoom = clamp(camera.zoom + zoom_speed, Vector2(2, 2), Vector2(10,10))
	if Input.is_action_pressed("zoom_out"):
		camera.zoom = clamp(camera.zoom - zoom_speed, Vector2(2, 2), Vector2(10,10))
	
	
	if Input.is_action_pressed("drag_camera"):
		var current_mouse_position = get_global_mouse_position()
		var delta = (current_mouse_position - prev_mouse_position) * drag_speed
		camera.global_position += delta
		prev_mouse_position = current_mouse_position
	elif Input.is_action_just_released("drag_camera"):
		prev_mouse_position = origin.global_position
		camera.global_position = origin.global_position
