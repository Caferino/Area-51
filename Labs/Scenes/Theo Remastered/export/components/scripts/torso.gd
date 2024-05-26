class_name Torso extends Limb

signal attack_finished()


func _on_torso_animator_animation_finished(anim_name: StringName) -> void:
	attack_finished.emit()
