class_name ItemHealing extends ItemUsable

var healing_amount


func _init(data, parent_item):
	super(data, parent_item)
	SignalManager.player_life_changed.connect(_on_player_life_changed)
	on_use_text = "Heal %s life points"
	condition = "Need healing"
	can_always_use = true


## Set the healing amount
func set_data(data):
	healing_amount = data.healing
	super.set_data(data)


## Show the healing amount
func get_use_text():
	return on_use_text % healing_amount


## The item is usble if the player is missing life points
func _on_player_life_changed(life, max_life):
	can_use = life < max_life


## Apply the healing
func execute():
	SignalManager.heal_player.emit(healing_amount)
	print("Healing the player for %s life point!" % healing_amount)
