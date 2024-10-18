extends PersonalityRole

### The Lumberjack ###
# Loves to chop wood and... and nothing else.

var goals : Array[GoapGoal] = [
	HasWoodGoal.new(),
	BuildFirepitGoal.new()
]

var actions : Array[GoapAction] = [
	ChopTreeAction.new(),
	CollectWoodAction.new(),
	BuildFirepitAction.new(),
	#FindCoverAction.new(),              # TODO - Move to a Combat/Survival Role
	#FindFoodAction.new(),               # TODO - Move to a Human/BasicNeeds Role
]

## The personal states of the entity. Different from _states in the GOAP AI.
## These are carried personally, unlike the original global WorldStates file.
## These help play with different values, priorities and costs calculations
## for each entity individually, giving a little further depth to their
## already-established personalities.
## These are managed and edited in the GOAP agent. This is a boilerplate for it.
var states : Dictionary = {
	"has_wood" : false,
	"has_firepit" : false
}
