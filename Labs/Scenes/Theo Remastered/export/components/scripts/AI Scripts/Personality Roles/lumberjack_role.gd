extends PersonalityRole

### The Lumberjack ###
# Loves wood.

var goals : Array[GoapGoal] = [
	ChoppedWoodGoal.new(),
	HasWoodGoal.new(),
	BuildFirepitGoal.new()
]

var actions : Array[GoapAction] = [
	ChopTreeAction.new(),
	CollectWoodAction.new(),
	BuildFirepitAction.new(),
]

## The personal states of the entity. Different from _states in the GOAP AI.
## These are carried personally, unlike the original global WorldStates file.
## These help play with different values, priorities and costs calculations
## for each entity individually, giving a little further depth to their
## already-established personalities.
## These are managed and edited in the GOAP agent. This is a boilerplate for it.
var states : Dictionary = {
	"chopped_wood" : false,
	"has_wood" : false,
	"has_firepit" : false,
	"need_wood" : 0,
	"chopped_wood_priority" : 0,
	"has_wood_priority" : 0,
	"has_firepit_priority" : 0
}
