extends Control

@export var order_button : Button  ## Player orders an action to an entity


func _ready() -> void:
	SignalManager.in_entity_vision_area.connect(_on_in_entity_vision_area)


## Listeners
func _on_in_entity_vision_area(entered : bool):
	if entered:
		order_button.disabled = false
		order_button.visible = true
	else:
		## WARNING - What if the player teleports / doesn't trigger area_exit?
		order_button.disabled = true
		order_button.visible = false


## Button presses
func _on_order_pressed() -> void:
	## WARNING TODO - Avoid spamming the button, OR set it as a toggle that stops/cancels the order
	## Imagine it like, "Working on it!" then immediatly "Alright, nevermind", "Working!", "Ok, no"
	print("Order sent!")
	var order = 0    ## Might change this to a String/StringName
	SignalManager.entity_order.emit(order)
	
	## WARN - Remember that functions connected to a signal run first than this print!
	print("Order received!")
	
	# What should happen:
	# 1. The NPC enters "Attention Mode", "Combat Mode" might share this; switches BT off, GOAP on.
	# 1.1 WARN - Can such mode be interrupted, switched off? How? Could break and stay on forever.
	# 1.2 NOTE - Remember: BT (Behavior Trees AIs) are cheaper than GOAP.
	# 2. The order given is a goal. GOAP should work on that.
	# 3. The most difficult features of this system might be the environment awareness,
	# the movement, the cancellations, pauses, resumes, interrupts, even being killed mid work...
	# 3.1 WARN - Regarding movement, it'd be cool if it wasn't a direct line to the center
	# of the goal, that is, direction_to() gives you the straight line towards the coords of the goal,
	# but that'd look unrealistic. People zig zag a little while walking. Rimworld does it perfectly,
	# but only because it has the advantage that the entire map is a grid, cells, they require to
	# zig zag sometimes. Here, it's an open field with a few obstacles, maybe. This will be tricky.
	# 3.2 WARN - Environment awareness could be pausing work if it begins to rain, seek shelter,
	# change plans but not forget the one you were doing earlier, so you can resume it.
	# 3.3 WARN - Interruptions or worse, getting attacked and killed, might be hard to do. Should
	# the entity flee or fight back? Ignore and just die? Surrender, beg? All at random, based on
	# personality like Rimworld kind of does (tough pawns fight back, coward ones flee)? This is far
	# ahead, but try to come up with something that might be easy to adapt the design for this.
	# 3.4 WARN - The "memory" system for each NPC, would it be too big or expensive? How to chop it?
