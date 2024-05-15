extends UIWindow

@export var player_data: PlayerData


func _ready():
	super()
	player_data.equipment.content_changed.connect(_on_content_changed)
	_on_content_changed(player_data.equipment.groups)


## Update the stats when items in the equipment group changes
func _on_content_changed(groups):
	if groups.find("equipment"):
		%lbl_str.text = str(player_data.get_stat(GameEnums.STAT.STRENGTH))
		%lbl_dex.text = str(player_data.get_stat(GameEnums.STAT.DEXTERITY))
		%lbl_int.text = str(player_data.get_stat(GameEnums.STAT.INTELLIGENCE))
		%lbl_vit.text = str(player_data.get_stat(GameEnums.STAT.VITALITY))
		%lbl_move_speed.text = str(player_data.get_stat(GameEnums.STAT.MOVE_SPEED))
