class_name HealthComponent extends Node
## The entity's [color=red]heart.

@export var entity : Entity = null  # TODO - For future better access to MAX_HEALTH
@export var health : float = 1.0  ## Total health points %.
@export var energy : float = 1.0  ## Total stamina %.


## Set the entity's health by the given amount.
func set_health(amount: float):
	## What if it exceeds MAX_HEALTH? Ignore or...
	## Apply as "shield", "overshield", "overhealth"?
	health = amount


## Take damage from a source (object, event, thing, phenomena).
func take_damage(_source: Node):
	## TBD - A source can be an item or thing, like a sword, fire or poisonous gas.
	## How to iterate through the source's effects/values? In a dynamic way
	## so that some of them can have attributes/properties others don't.
	pass


## Heal an amount of damage from a source (object, event, thing, phenomena).
func take_heal(_source: Node):
	## TBD - Might work the same as take_damage, but, think about:
	## What if it exceeds MAX_HEALTH? Ignore or...
	## Apply as "shield", "overshield", "overhealth"? Stuff like that.
	## How does Tibia, Runescape or WoW do it?
	pass


## Directly damage the entity by the given amount.
func damage(amount: float):
	health -= amount
	if health < 0:
		health = 0


## Directly heal the entity by the given amount.
func heal(amount: float):
	health += amount
	if health > get_parent().MAX_HEALTH:
		health = get_parent().MAX_HEALTH
