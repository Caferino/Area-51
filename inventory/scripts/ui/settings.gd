extends UIWindow

@export var settings_data : SettingsData

func _ready():
	super()
	%min.text = "Min: %s" % %scale_slider.min_value
	%max.text = "Max: %s" % %scale_slider.max_value
	settings_data.changed.connect(_on_data_changed)
	#print("Is this piece of shit executing too? WHy the fuck true? ", settings_data.fullscreen)
	#_on_data_changed()
	#print("Yup, it is ")
	set_scale_label()


func _on_close_pressed():
	hide()


## Update the scale of the UI using the ScaleControl
func _on_scale_slider_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		SettingsManager.ui_scale = %scale_slider.value
		set_scale_label()


## Change the fullscreen toggle
func _on_CheckBox_toggled(button_pressed):
	SettingsManager.fullscreen = button_pressed


## Update the inputs when the data changes (Ex: On game load)
func _on_data_changed():
	%fullscreen_check.button_pressed = settings_data.fullscreen
	%scale_slider.value = settings_data.ui_scale


func set_scale_label():
	%current_scale.text = "- Scale: %s -" % SettingsManager.ui_scale
