extends Node

const SPELLS_PATH: String = "res://Labs/Scenes/Magic System/"

## All the spells
# TODO - Maybe load core/common ones with preload, and complex ones with lazy loads
var spell: Dictionary = {
	GameEnums.SPELLS.FIREBALL : preload(SPELLS_PATH + "Fireball/fireball_spell.tscn")
}
