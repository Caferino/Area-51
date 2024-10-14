class_name Weapon extends Node

## Structure should be as follow
## Weapon                           : Marker2D
## > child 0: SwordArea             : Area2D
## > > child 0: SwordCollisionShape : CollisionShape2D
## > > child 1: SwordSprite         : Sprite2D
## > child 1: SwordAnimator         : AnimationPlayer


var attack_stats = {
	GameEnums.ATTACK_STAT.WEAPON_SPEED      :   2,      # speed_scale = [-4, 4] in Godot
	GameEnums.ATTACK_STAT.WEAPON_DAMAGE     :  10,
	GameEnums.ATTACK_STAT.KNOCKBACK_POWER   : 100
}


