extends ConditionLeaf


func tick(actor, _blackboard):
	if actor.moving:
		return FAILURE
	else:
		return SUCCESS
