class_name Melee_Weapon extends Weapon

@export var animator        : AnimationPlayer
@export var sprite          : Sprite2D
@export var collision_shape : CollisionShape2D


func _ready():
	sprite.visible = false
	collision_shape.disabled = true
	animator.speed_scale = attack_stats[GameEnums.ATTACK_STATS.WEAPON_SPEED]


func draw():
	sprite.visible = true
	collision_shape.disabled = false


func sheathe():
	sprite.visible = false
	collision_shape.disabled = true
