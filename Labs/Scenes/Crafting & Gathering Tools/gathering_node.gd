extends Marker2D
## A gathering node (rock or herb).

## NOTE WARN - If it's a herb, remove the StaticBody child node, so the player
## can walk through it as it should. If it's a rock, leave it.

@export var attributes : Resource        = null ## The node's attributes/stats
@export var animator   : AnimationPlayer = null
@export var sprite     : Sprite2D        = null


var required_tool_type = {
	GameEnums.NODE_TYPE.ROCK: GameEnums.TOOL_TYPE.PICKAXE,
	GameEnums.NODE_TYPE.HERB: GameEnums.TOOL_TYPE.SICKLE,
	## Can add more here
}


func _ready() -> void:
	sprite.texture = attributes.texture


## This function gets the tool needed to interact with this node's type and
## then, if it's the correct one, receives damage or whatever else is desired.
func interact(item: GatheringTool):
	var correct_tool = required_tool_type.get(attributes.type)
	if correct_tool != null and item.attributes.type == correct_tool:
		take_damage(item.attributes.damage)


func take_damage(damage: float):
	animator.play("gathering_node/shake")
	attributes.health -= damage
	attributes.health = clamp(attributes.health, 0, attributes.max_health)
	change_frame()
	
	if attributes.health <= 0:
		## WIP - Explode Animation...
		drop_debris()
		drop_reagents()
		queue_free()


func change_frame():
	var health_ratio = attributes.health / attributes.max_health
	
	if health_ratio > 2.0/3.0:
		sprite.frame = 0
	elif health_ratio > 1.0/3.0:
		sprite.frame = 1
	elif attributes.health > 0:
		sprite.frame = 2


func drop_debris():
	var amount = randi_range(5, 15)
	for i in range(0, amount):
		ResourcesManager.drop_debris("Debris", "coal" + "_debris", global_position, attributes.loot_radius, self.get_parent())


func drop_reagents():
	var amount = randi_range(attributes.drop_rate.x, attributes.drop_rate.y)
	for i in range(0, amount):
		ResourcesManager.drop_item("Reagents", "coal", global_position, attributes.loot_radius, self.get_parent())
