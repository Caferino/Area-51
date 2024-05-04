extends Node

@export var health_component : HealthComponent

func receive_damage(amount):
	if health_component:
		health_component.damage(amount)


# Every entity with a HitboxComponent has to be interactive (or pass)
func interact(item):
	get_parent().interact(item)
