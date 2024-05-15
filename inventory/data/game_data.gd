class_name GameData extends Resource

@export var settings_data_resource : SettingsData
@export var player_data_resource   : PlayerData


## Set the data form a Dictionary
func set_data(data):
	settings_data_resource.set_data(data.settings_data_resource)
	player_data_resource.set_data(data.player_data_resource)
	emit_changed()


## Pack the data in a Dictionary
func get_data():
	return {
		"settings_data_resource" : settings_data_resource.get_data(),
		"player_data_resource"   : player_data_resource.get_data()
	}
