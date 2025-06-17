class_name Debris extends RigidBody2D


@onready var sprite   : Sprite2D        = $DebrisSprite
@onready var animator : AnimationPlayer = $DebrisAnimator
@export var _data     : Resource        = null
@export var dropped   : bool            = false


func setup(data: Resource) -> void:
	_data = data


func _ready() -> void:
	sprite.texture = _data.texture
	sprite.frame = _data.frame
	if dropped:
		await get_tree().create_timer(randi() % 31 + 20).timeout
		animator.play("fade_out")


func drop(radius: Vector2):
	dropped = true
	var direction = Randomizer.random_point_around(radius)
	apply_central_impulse(direction * (randf() * 5 + 5))
	apply_torque_impulse(randf() * 5 + 5)
	await get_tree().create_timer(randi() % 31 + 60).timeout
	animator.play("fade_out")


func _on_debris_animator_animation_finished(_anim_name: StringName) -> void:
	queue_free()
