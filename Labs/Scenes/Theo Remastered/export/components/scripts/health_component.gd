class_name HealthComponent extends Node
## The entity's [color=red]heart.

@export var entity : Entity = null  # TODO - For future better access to MAX_HEALTH
@export var health : float = 1.0  ## Total health points %.
@export var energy : float = 1.0  ## Total stamina %.


## Set the entity's health by the given amount.
func set_health(amount: float):
	health = amount


## Damage the entity by the given amount.
func damage(amount: float):
	health -= amount
	if health < 0:
		health = 0


## Heal the entity by the given amount.
func heal(amount: float):
	if health + amount >= get_parent().MAX_HEALTH:  # ! TODO - I do not like get_parent(), breaks easily
		health = get_parent().MAX_HEALTH
	else: 
		health += amount
