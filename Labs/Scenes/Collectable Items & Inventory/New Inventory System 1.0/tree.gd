extends Node2D

@export var health_component : HealthComponentOld
var initial_health := randi_range(4, 6)
var MAX_HEALTH := 10.0
var loot_radius = Vector2(40.0, 50.0)  ## Ring
var state = 1                          ## 1 == Grown Tree;  0 == Stump


func _ready() -> void:
	health_component.set_health(initial_health)
	$AnimatedSprite.play("tree")


func interact(item):
	if item == "hatchet":   # TODO Testing. Replace with an "attack" object
		health_component.damage(1)
		if state == 1: drop_logs()
		if health_component.health == 0:
			on_depleted_health(item)


func on_depleted_health(with):
	if with == "shovel":       
		queue_free()
	elif state == 1:   # TODO Tree hit with anything, skew/rotate sprite
		state = 0
		$AnimatedSprite.play("stump")
		$GrowthTimer.start()


func _on_growth_timer_timeout() -> void:
	if state == 0:   # 1 == Grown Tree;  0 == Stump
		state = 1
		$AnimatedSprite.play("tree")
		health_component.set_health(initial_health)


func drop_logs():
	ItemManager.drop_item("logs", global_position, loot_radius, self.get_parent())
