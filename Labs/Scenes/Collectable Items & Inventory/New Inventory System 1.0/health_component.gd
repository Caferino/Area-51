extends Node
class_name HealthComponentOld

var health : float


func set_health(amount):
	health = amount


func damage(amount):
	health -= amount
	if health < 0:
		health = 0


func heal(amount):
	health += amount
	if health > get_parent().MAX_HEALTH:
		health = get_parent().MAX_HEALTH
