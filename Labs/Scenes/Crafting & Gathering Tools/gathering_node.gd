extends Marker2D
## A gathering node (rock or herb).

## NOTE WARN - If it's a herb, remove the StaticBody child node, so the player
## can walk through it as it should. If it's a rock, leave it.

@export var attributes : Resource = null ## The node's attributes/stats
@export var animator   : AnimationPlayer = null

func interact(item_type: GameEnums.TOOL_TYPE):
	if item_type == null:
		return
	
	## The level should probably add it to either the group rock or herb
	## depending on the procedurally generated algorithm's choice.
	## Two ifs to check whether the correct tool was used, and,
	## WARN - instead of checking for every type of tool (bronze, stone, diamond...),
	## just use the tool's strength/damage value, to avoid so many ifs.
	if attributes.type == GameEnums.NODE_TYPE.ROCK:
		if item_type == GameEnums.TOOL_TYPE.PICKAXE:
			## Correct tool, apply damage
			## NOTE - Should the check HP < n be here or in a signal in case
			## other things other than a pickaxe do damage to it and I need
			## to change the frame?
			print("MINING ROCK")
			animator.play("gathering_node/shake")
	elif attributes.type == GameEnums.NODE_TYPE.HERB:
		if item_type == GameEnums.TOOL_TYPE.SICKLE:
			## Correct tool, apply damage
			print("CUTTING HERB")
