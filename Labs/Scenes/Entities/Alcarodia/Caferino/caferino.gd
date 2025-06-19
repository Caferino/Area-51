extends Alcarodia
## The [color=brown]Brown God.

## Caferino has a keen eye over the player.
var player_scene = preload("res://Labs/Scenes/Theo Remastered/Smoke Ashburn.tscn")
var player : Human = null

## All the entities Caferino has created.
# "CAFERINO" is a const declared in Alcarodia.gd, a path (like "res://...")
var entities: Dictionary = {
	GameEnums.CAFERINO.HUMAN : preload(CAFERINO + "Human/human.tscn")
}


func spawn_player() -> Entity:
	return player_scene.instantiate()


## Spawn a given entity.
func spawn(entity_name: GameEnums.CAFERINO = GameEnums.CAFERINO.NONE, _race_name: String = "default") -> Entity:
	var entity = entities[entity_name].instantiate()
	return entity
