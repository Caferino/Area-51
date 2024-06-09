extends DelayDecorator

func tick(actor: Node, blackboard: Blackboard):
	wait_time = randf_range(2, 5)  ## TODO - These can be fed from a database/entity stats in the future
	#super.tick(actor, blackboard)
