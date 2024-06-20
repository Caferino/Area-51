extends Alcarodia
## The [color=green]God of Nature.

const ENTITIES_PATH: String = ""

var animals: Dictionary = {
	"CaveBat" = {
		GameEnums.AI_STATS.DEFAULT_MAX_SPEED      : 250,
		GameEnums.AI_STATS.DEFAULT_LOOK_AHEAD     :  50,
		GameEnums.AI_STATS.DEFAULT_ADDED_INTEREST : 5.0,
		GameEnums.AI_STATS.DEFAULT_NUM_RAYS       :   8, # TODO - Maybe this should never change at all for most entities (1)
		GameEnums.AI_STATS.DEFAULT_BACKOFF_SPEED  : 0.2
	}
}


var plants: Dictionary = {
	trees = {
		"WoodenTree" = 1
	}
}

