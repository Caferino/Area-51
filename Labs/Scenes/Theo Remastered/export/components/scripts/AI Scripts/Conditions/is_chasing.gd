extends ConditionLeaf


func tick(actor, _blackboard):
	if actor.chasing:
		return SUCCESS
	else:
		return SUCCESS
