class_name SettingsData extends Resource

@export var fullscreen : bool = false
@export var ui_scale   : float = 2

func set_data(data):
	fullscreen = data.fullscreen
	ui_scale = data.ui_scale
	#emit_changed()


func get_data():
	return {
		"fullscreen": fullscreen,
		"ui_scale" : ui_scale
	}
