extends Area2D

@export var sprite   : AnimatedSprite2D = null
@export var animator : AnimationPlayer  = null
@onready var tween   : Tween            = create_tween()
var item_name        : String           = ""
var item_qty         : int              = 1


func setup(item):
	item_name = item.name
	sprite.get_sprite_frames().add_frame("default", item.texture)
	for g in item.groups: add_to_group(g)


func drop(loot_radius: Vector2):
	var direction = Randomizer.random_point_around(loot_radius)
	sprite.set_scale(Vector2(0.0, 0.0))
	tween.set_parallel()
	tween.tween_property(self, "position", global_position + direction, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(sprite, "scale", Vector2(0.4, 0.4), 0.5)
	tween.tween_property(sprite, "rotation_degrees", 720, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.play()
	hover()


func pick_up():
	set_deferred("monitorable", false)
	animator.play("pickables/pick_up")
	await get_tree().create_timer(animator.current_animation_length).timeout
	queue_free()


func hover():
	animator.play("pickables/hover")
