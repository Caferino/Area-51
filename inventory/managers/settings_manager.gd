extends Node

var fullscreen : set = set_fullscreen
var ui_scale : set = set_ui_scale
var settings_data: SettingsData


func _ready():
	settings_data = preload("res://inventory/data/resources/settings_data.tres")
	ui_scale = settings_data.ui_scale
	fullscreen = settings_data.fullscreen
	settings_data.changed.connect(_on_data_changed)
	print("why the fuck is this executing _on_data_changed?")


func set_fullscreen(value):
	fullscreen = value
	print("What the fuck?? ", value)
	get_window().mode = Window.MODE_FULLSCREEN if (value) else Window.MODE_WINDOWED
	print("What the fuck????? ", get_window().mode)
	settings_data.fullscreen = value


func set_ui_scale(value):
	ui_scale = value
	SignalManager.ui_scale_changed.emit(value)
	settings_data.ui_scale = value


func _on_data_changed():
	set_fullscreen(settings_data.fullscreen)
	set_ui_scale(settings_data.ui_scale)
