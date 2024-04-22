extends Node2D

var state = 1  # 1 == Grown Tree, 0 == Cut Tree (Stump)
var player_in_area = false

var logs = preload("res://Labs/Scenes/Collectable Items/Collectable.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if state == 0:
		$GrowthTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == 0:   # if cut
		$AnimatedSprite.play("stump")
	else:  # it's grown
		$AnimatedSprite.play("tree")
		if player_in_area:
			if Input.is_action_just_pressed("interact"):
				state = 0
				drop_logs()
				$GrowthTimer.start()


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = true


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = false


func _on_growth_timer_timeout() -> void:
	if state == 0:   # if tree is cut
		state = 1


func drop_logs():
	var logs_instance = logs.instantiate()
	logs_instance.global_position = $Spawner.global_position
	get_parent().add_child(logs_instance)
	
