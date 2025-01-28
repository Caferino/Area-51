extends Alcarodia
## The [color=brown]Brown God.

## All the entities Caferino has created.
# "CAFERINO" is a const declared in Alcarodia.gd, a path (like "res://...")
var entities: Dictionary = {
	GameEnums.CAFERINO.HUMAN : preload(CAFERINO + "Human/human.tscn")
}


## Spawn a given entity.
func spawn(entity_name: GameEnums.CAFERINO = GameEnums.CAFERINO.NONE, _race_name: String = "default") -> Entity:
	var entity = entities[entity_name].instantiate()
	return entity
