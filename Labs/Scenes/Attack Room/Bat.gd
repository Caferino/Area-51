class_name Bat extends RigidBody2D

@onready var sprite = $BatSprite
@onready var effects_animator = $EffectsAnimator
var context_map = [      # TODO - Put these in a component for any NPC to use
	Vector2(0, -1),      #   ↑
	Vector2(1, -1),      #   ↗
	Vector2(1, 0),       #   →
	Vector2(1, 1),       #   ↘
	Vector2(0, 1),       #   ↓
	Vector2(-1, 1),      #   ↙
	Vector2(-1, 0),      #   ←
	Vector2(-1, -1)      #   ↖
]


func _ready():
	gravity_scale = 0
	add_to_group("Enemies")
	sprite.play("fly_right")


func pushback(force_origin_position, knockback_power):
	var direction = global_position - force_origin_position
	direction = sign(direction)
	apply_impulse(direction * knockback_power)


func hurt():
	effects_animator.play("effects/hit_flash")
