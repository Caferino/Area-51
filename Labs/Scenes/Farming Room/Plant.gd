extends Node2D

@onready var plant = $Sprite
@onready var timer = $Timer
var stage = 0


func _ready():
	plant.frame = stage
	timer.start(randi_range(1, 10))


func _on_timer_timeout():
	if stage < 5:
		stage += 1
	else:
		stage = 0
	plant.frame = stage
	timer.start(randi_range(1, 10))
