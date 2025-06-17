extends Area2D
## Static collectable. TODO - Animated Collectable, just the sprite changes, and create SpriteFrames
## as RESOURCES (.tres) for them, to save memory. E.x. Dragonsoul drops, enchanted items, magic...

@export var item_qty  : int              = 1
@export var item_name : String           = ""
@export var sprite    : Sprite2D         = null
@export var animator  : AnimationPlayer  = null
@export var _data     : Resource         = null
@export var dropped   : bool             = false


func setup(data):
	_data = data


func _ready() -> void:
	item_name = _data.name
	sprite.texture = _data.texture
	for g in _data.groups: add_to_group(g)
	if dropped:
		hover()


func drop(radius: Vector2):
	dropped = true
	var direction = Randomizer.random_point_around(radius)
	sprite.set_scale(Vector2(0.0, 0.0))
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "global_position", global_position + direction, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
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
