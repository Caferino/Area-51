class_name Debris extends RigidBody2D


@export var sprite   : Sprite2D = null
@export var animator : AnimationPlayer = null


func setup(data) -> void:
	sprite.texture = data.texture
	sprite.frame = randi_range(0, 7)


func drop(radius: Vector2):
	var direction = Randomizer.random_point_around(radius)
	apply_central_impulse(direction * (randf() * 5 + 5))
	apply_torque_impulse(randf() * 10 + 7)
	await get_tree().create_timer(randi() % 31 + 60).timeout
	animator.play("fade_out")


func _on_debris_animator_animation_finished(_anim_name: StringName) -> void:
	queue_free()
