extends ConditionLeaf


func tick(actor, _blackboard):
	if actor.is_chasing:
		return SUCCESS
	else:
		return SUCCESS
