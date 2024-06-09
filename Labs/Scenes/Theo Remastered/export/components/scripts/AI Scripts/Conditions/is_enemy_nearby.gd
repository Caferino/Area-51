extends ConditionLeaf

func tick(actor, _blackboard):
	if actor.is_enemy_nearby:
		return SUCCESS
	else:
		return FAILURE
