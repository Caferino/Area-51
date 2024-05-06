class_name HotbarNode extends ScaleControl

@export var player_data: PlayerData

var slots: Array = []


## Draw the hotbar slot from the player data
func _ready():
	super()
	for slot in player_data.hotbar.slots:
		var slot_node = AlcarodianResourceManager.get_instance("hotbar_slot_node")
		%slot_container.add_child(slot_node)
		slot_node.slot = slot
		slots.append(slot)
