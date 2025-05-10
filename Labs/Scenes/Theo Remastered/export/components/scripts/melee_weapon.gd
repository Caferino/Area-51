class_name MeleeWeapon extends Tool
## A warrior's best friend.

## Structure should be as follow:
## Weapon                            : Marker2D
## > child(0): SwordArea             : Area2D
## > > child(0): SwordCollisionShape : CollisionShape2D
## > > child(1): SwordSprite         : Sprite2D
## > child(1): SwordAnimator         : AnimationPlayer

signal attack_finished()  ## Emitted after the weapon's attack ends.

var tool_stats = {
	GameEnums.TOOL_STAT.SPEED     :   2,      # speed_scale = [-4, 4] in Godot
	GameEnums.TOOL_STAT.DAMAGE    :  10,
	GameEnums.TOOL_STAT.KNOCKBACK : 100
}


## Prepares the weapon by hiding it and updating its speed stat from a database.
func _ready():
	get_child(0).get_child(1).visible = false
	get_child(0).monitoring = false
	get_child(1).speed_scale = tool_stats[GameEnums.TOOL_STAT.SPEED]


## Runs after the weapon's attack animation ends.
func _on_melee_weapon_animator_animation_finished(_anim_name: StringName):
	attack_finished.emit()
