class_name MeleeWeapon extends Weapon

signal attack_finished()

func _ready():
	sprite.visible = false
	area.monitoring = false
	animator.speed_scale = attack_stats[GameEnums.ATTACK_STATS.WEAPON_SPEED]


func _on_melee_weapon_animator_animation_finished(_anim_name):
	attack_finished.emit()
