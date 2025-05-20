class_name MeleeWeapon extends Tool
## A warrior's best friend.

@export var origin   : CollisionShape2D = null ## Perfect for knockback push directions


## Prepares the weapon by hiding it and updating its speed stat from a database.
func _ready():
	tool_area.monitoring = false
	sprite.texture  = attributes.texture
	animator.speed_scale = attributes.speed


func _on_melee_weapon_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Plant"):
		area.get_parent().take_damage(GameEnums.WEAPON_TYPE.SLASH)


func _on_melee_weapon_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		print("get hit!")
		body.hurt(self)
