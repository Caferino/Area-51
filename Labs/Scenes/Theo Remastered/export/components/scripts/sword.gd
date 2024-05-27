class_name Sword extends MeleeWeapon

func _on_sword_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Plants"):
		area.take_damage(GameEnums.WEAPON_TYPE.SLASH)
