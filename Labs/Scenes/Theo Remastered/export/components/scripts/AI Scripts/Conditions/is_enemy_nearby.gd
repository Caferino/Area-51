extends ConditionLeaf

func tick(actor, _blackboard):
	if actor.enemy_nearby:
		return SUCCESS
	else:
		return FAILURE
