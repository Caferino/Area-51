extends PersonalityRole

### The Lumberjack ###
# Loves to chop wood and... and nothing else.

var goals : Array[GoapGoal] = [
	KeepFirepitBurningGoal.new()
]

var actions : Array[GoapAction] = [
	ChopTreeAction.new(),
	CollectWoodAction.new(),
	BuildFirepitAction.new(),
	#FindCoverAction.new(),              # TODO - Move to a Combat/Survival Role
	#FindFoodAction.new(),               # TODO - Move to a Human/BasicNeeds Role
]
