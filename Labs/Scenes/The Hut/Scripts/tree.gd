class_name WoodenTree extends Node2D
## A [color=green]tree.

## TODO - Should extend a class named "Plant" with general stats in common

## This script should define all the stats trees share in common
## and also the methods they all have, unless
## each type of tree (small, big, etc.) should have their own
## "interact()" method for whatever they do. This could work as an interface

@export var health_component       : HealthComponent       ##
@export var timer_component        : TimerComponent        ##
@export var appearance_component   : AppearanceComponent   ##

var initial_health           = randf_range(4, 6)     ## This should go in the unique tree class
var loot_radius              = Vector2(80.0, 100.0)  ## Ring ## TODO - Make it based on size
var state                    = 1                     ## 0 = Stump, 1 = Grown
var size                     = 1                     ## Size of the tree (1 = small, 2 = big)


## Connects the necessary components.
func _ready():
	timer_component.timers["GrowthTimer"].timeout.connect(_on_growth_timer_timeout)


#func set_intial_health(min, max):
	#initial_health = randf_range(min, max)


## All trees should be interactable with a hatchet and more.
## If a tree is special, overwrite this function and call it after or before
## the special interaction with super.interact().
func interact(item: String = ""):
	if item == "":
		return
	elif item == "hatchet":
		health_component.damage(1)
		if state == 1: drop_logs()
		if health_component.health == 0 and timer_component.timers["GrowthTimer"].is_stopped():
			on_depleted_health(item)
	elif item == "shovel":
		if health_component.health == 0: ## TODO - and if stump
			on_depleted_health(item)


## All trees should behave the same when their health depletes.
## In this case, if it's a trunk and it's being interacted with a shovel,
## remove the entire tree from the game. Otherwise...
func on_depleted_health(with):
	if with == "hatchet":  # TODO Tree hit with anything, skew/rotate sprite
		state = 0
		appearance_component.assets["Leaves"].hide()
		timer_component.timers["GrowthTimer"].start()
	elif with == "shovel":       
		queue_free()


func _on_growth_timer_timeout():
	if state == 0:  ## 0 == Stump, 1 == Grown  
		state = 1
		appearance_component.assets["Leaves"].show()
		health_component.set_health(initial_health)


func drop_logs():
	ItemManager.drop_item("logs", global_position, loot_radius, self.get_parent())
