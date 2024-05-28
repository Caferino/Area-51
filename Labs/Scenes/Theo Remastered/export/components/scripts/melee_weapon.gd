class_name MeleeWeapon extends Weapon

## Structure should be as follow
## Weapon                            : Marker2D
## > child(0): SwordArea             : Area2D
## > > child(0): SwordCollisionShape : CollisionShape2D
## > > child(1): SwordSprite         : Sprite2D
## > child(1): SwordAnimator         : AnimationPlayer

signal attack_finished()


func _ready():
	get_child(0).get_child(1).visible = false
	get_child(0).monitoring = false
	get_child(1).speed_scale = attack_stats[GameEnums.ATTACK_STATS.WEAPON_SPEED]


func _on_melee_weapon_animator_animation_finished(_anim_name):
	attack_finished.emit()
