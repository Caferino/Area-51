extends ConditionLeaf


func tick(actor, _blackboard):
	if actor.is_moving:
		return FAILURE
	else:
		return SUCCESS
