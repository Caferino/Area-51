extends Alcarodia
## The [color=brown]Brown God.

## TODO - Caferino's DB is in the other project. Bring it here, now.
const ENTITIES_PATH: String = "res://Labs/Scenes/Caferino/"

## All the entities Caferino has created.
var entities: Dictionary = {
	"Human" : preload("res://Labs/Scenes/Caferino/Human/human.tscn")
}


## Spawn a given entity.
func spawn(entity_name: String = "", _race_name: String = "default") -> Entity:
	var entity = entities[entity_name].instantiate()
	return entity
