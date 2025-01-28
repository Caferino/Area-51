extends Node

## Usually, adding children to the level is messy; it usually requires to spam
## "get_parent()" and more. This Manager should solve that, it should hold
## a reference to the current level(s) to help with, transitions, spawns...

## To keep it simple, I only need one current level at the time in this game,
## however, in the future, I might use an array to deal with multiple levels.
## I don't know how, haven't designed it yet, but it could open for potential
## cool stuff; managing lands from home, controlling NPCs very far away...
var curr_level : Level = null


func _ready() -> void:
	SignalManager.connect_levels.connect(add_level)


# TODO - In the distant future, if using an array, this should be easy to adapt... I hope
func add_level(level: Level):
	curr_level = level


# TODO - Receive a level to remove from the array of multiple levels in the future
func remove_level(_level: Level):
	curr_level = null


func spawn(object: Node2D, spot: Node2D):
	if object.get_parent():
		print("Reparenting...")
		object.reparent(curr_level)
	else:
		print("Directly adding object to the level...")
		curr_level.add_child(object)
	object.global_position = spot.global_position


## WARN TODO - I can foresee issues when dealing with multiple levels.
## How to know in which one to spawn or add the child? Keep track of them...
## For this... Do children inherit the group(s) of the parent node? That'd fix all
