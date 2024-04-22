extends Area2D

# TODO - Recreate this as a "collectable.tscn" and "collectable.gd"
# It should be able to receive a JSON or something that tells it:
# The sprite to use (logs, crops, weapons, loot, anything droppable)
# Speed of animations, scale range for randomized size, maybe weight too...
# Maybe keep the animation speed the same, but you get the idea.
# ! Weight would be problematic if it matters. Kiss stacks bye bye. Avoid imo.

# TODO - Make the Player's Area2D monitor/scan items, not each of them.

# TODO - Fuse multiple items of the same type together


func _ready() -> void:
	fall_from_tree()  # WIP, Working with tree logs


func fall_from_tree():
	$AnimationPlayer.play("pickables/falling_from_tree")
	await get_tree().create_timer(0.45).timeout
	monitorable = true


func pick_up_item():
	monitorable = false
	$AnimationPlayer.play("pickables/pick_up")
	await get_tree().create_timer(2).timeout
	queue_free()


#func _on_area_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#$AnimatedSprite/Area.monitorable = false
		#$AnimatedSprite/Area/AnimationPlayer.play("pick_up")
		#await get_tree().create_timer(2).timeout
		#queue_free()

