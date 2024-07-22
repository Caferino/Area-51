class_name HangingDecor extends RigidBody2D

var held : bool = false

func _on_body_entered(_body: Node) -> void:
	if not held:
		held = true
		await get_tree().create_timer(0.5).timeout
		$BottomCollisionShape.disabled = true
		await get_tree().create_timer(0.05).timeout
		$BottomCollisionShape.disabled = false
		held = false
