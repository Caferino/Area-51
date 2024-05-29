class_name HealthComponent extends Node
## The entity's [color=red]heart.

var health : float  ## Total health points.


## Set the entity's health by the given amount.
func set_health(amount):
	health = amount


## Damage the entity by the given amount.
func damage(amount):
	health -= amount
	if health < 0:
		health = 0


## Heal the entity by the given amount.
func heal(amount):
	health += amount
	if health > get_parent().MAX_HEALTH:  # ! TODO - I do not like get_parent(), breaks easily
		health = get_parent().MAX_HEALTH
