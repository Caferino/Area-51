class_name Sword extends MeleeWeapon

## Structure should be as follow
## Weapon                            : Marker2D
## > child(0): SwordArea             : Area2D
## > > child(0): SwordCollisionShape : CollisionShape2D
## > > child(1): SwordSprite         : Sprite2D
## > child(1): SwordAnimator         : AnimationPlayer


func _on_sword_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Plants"):
		area.take_damage(GameEnums.WEAPON_TYPE.SLASH)


func _on_sword_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.hurt(get_child(0).get_child(0).position)
