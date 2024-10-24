class_name BuildFirepitGoal extends GoapGoal

func get_class_name(): return "BuildFirepitGoal"

func is_valid(_agent) -> bool:
	# Fuck, this is hard
	#return agent.controller.entity.inventory.items["Logs"] >= agent.states["need_wood"]
	return true


func priority(agent) -> int:
	return agent.states["has_firepit_priority"]

## NOTE - How to build a firepit?
## THE UGLY: Loop until overlap_areas or whatever is false. What if it never finishes or is long?
## THE BAD: Like the ugly, but with RNG coordinates around the map.
## THE GOOD: Set pre-defined build areas, but this breaks immersion and openness, it sucks balls
## WARN THE CHOSEN ONE: Graal's with overlap check for big structures, none for decoratives, by layers
## ---
## Does the entity have to move to the build spot? Or can it spawn the firepit from anywhere,
## as if it entered a build mode itself? How would building work in the game? Like Graal or Ark?
## That is, in Graal you can drag and place it anywhere in the screen.
## In Ark you have to walk and be close to where you want it, in 2D this shouldn't be too different.
## In other games you can spawn it in front of you, where you're facing, just a button press.
## The overlap check will probably suck, specially in crowded spaces like a house, so.....
## Maybe the Graal's one is the best choice to avoid that.
## MAYBE it should be like Graal's, but with an overlap check, depending on the item's layer.
## This increases the challenge, it'd be as hard as it can get:
## Dragging the item/furniture to place anywhere in the screen, it should highlight-transparently
## in color green if it can be placed (static bodies don't overlap), otherwise turn red.
## Small items like decorations, those with no static bodies, or maybe some do have it like lamps,
## can be placed on top of others, maybe, this is going to be a kick in the butt, but if it works,
## it will be insane. However, leave this for much, much later, not now, keep it simple to finish GOAP.
## 
## Maybe, to keep the realism, you place a transparent white "blueprint" of the furniture, and you must
## move to the spot to place it, except decorative items (they might be unreachable), but maybe this
## is not a good idea. This tech would be so useful for a lot of spell-casts and a Shaman class and 
## its totems, like WoW, but 2D. Tibia having a baby with WoW and Zelda, A Link to the Past, with 
## endless dungeons, gameplay loops on the feeling of combining different spells and weapons, 
## massacring hundreds of enemies maybe, like in Diablo. Have a slow-paced farming, crafting and 
## building side, heavy resources sink, that akins to the gameplay style RDR2 tries to enforce. 
## This shit is insane, too big, but fuck it. Do it for fun. 
## Just get a real job and do this shit on the side already, after GOAP.


func get_desired_state() -> Dictionary:
	return {
		"has_firepit": true
	}
