extends Area2D

@onready var tween = create_tween()
var animator
var sprite


func setup(item):
	animator = $AnimationPlayer
	sprite   = $AnimatedSprite
	set_name(item.name)
	set_texture(item.texture)


func set_texture(texture : Texture2D):
	sprite.get_sprite_frames().add_frame("default", texture)


func drop(loot_radius: Vector2):
	tween.set_parallel()
	var direction = Randomizer.random_point_around(loot_radius)
	tween.tween_property(self, "position", global_position + direction, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	sprite.set_scale(Vector2(0.0, 0.0))
	tween.tween_property(sprite, "scale", Vector2(0.4, 0.4), 0.5)
	tween.tween_property(sprite, "rotation_degrees", 720, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.play()
	hover()


func pick_up():
	animator.play("pickables/pick_up")
	await get_tree().create_timer(animator.current_animation_length).timeout
	queue_free()


func hover():
	animator.play("pickables/hover")
