extends UIWindow

@export var settings_Data : SettingsData


func _ready():
	super()
	


func _on_close_button_pressed() -> void:
	hide()


func _on_scale_slider_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		SettingsManager.current_scale = scale_slider.value


func _on_fullscreen_check_box_toggled(button_pressed: bool) -> void:
	SettingsManager.fullscreen = button_pressed
