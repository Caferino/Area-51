class_name Bat extends RigidBody2D

@onready var sprite = get_node("BatSprite")
@onready var effects_animator = $BatSprite/EffectsAnimator


# Called when the node enters the scene tree for the first time.
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
