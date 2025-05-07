extends Marker2D
## A gathering node (rock or herb).

## NOTE WARN - If it's a herb, remove the StaticBody child node, so the player
## can walk through it as it should. If it's a rock, leave it.

var health : float = 100.0

func take_damage(item: String = ""):
	if item == "":
		return
	
	## The level should probably add it to either the group rock or herb
	## depending on the procedurally generated algorithm's choice.
	## Two ifs to check whether the correct tool was used, and,
	## WARN - instead of checking for every type of tool (bronze, stone, diamond...),
	## just use the tool's strength/damage value, to avoid so many ifs.
	if is_in_group("RockNode"):
		if item == "pickaxe":
			## Correct tool, apply damage
			## NOTE - Should the check HP < n be here or in a signal in case
			## other things other than a pickaxe do damage to it and I need
			## to change the frame?
			pass
	elif is_in_group("HerbNode"):
		if item == "sickle":
			## Correct tool, apply damage
			pass
