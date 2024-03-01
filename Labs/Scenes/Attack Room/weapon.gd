class_name Weapon extends Node2D

signal attacked

# Imagine this came from a dagger's data in a JSON file...
var weapon_speed    = 2      # speed_scale = [-4, 4] in Godot
var weapon_damage   = 10
var knockback_power = 100.0
@onready var sprite = $WeaponSprite
@onready var animator = $WeaponAnimator
@onready var collision_shape = $HitBox/CollisionShape


func _ready():
	sprite.visible = false
	collision_shape.disabled = true
	animator.speed_scale = weapon_speed


func _input(_event):
	if Input.is_action_just_pressed("attack"):
		attack()


func attack():
	attacked.emit(self)


func _on_hit_box_area_entered(area):
	var target = area.get_parent()
	if target.is_in_group("Plants"):
		cut_plant(target)
	if target.is_in_group("Enemies"):
		target.pushback(global_position, knockback_power)
		target.hurt()


func cut_plant(target):
	var strength = 0.025
	# TODO - Any way to stop the growth's shake while getting cut at the same time?
	target.shake(strength)
	target.drop_leaves()
	await get_tree().create_timer(strength * 5).timeout
	target.current_stage = 1
	target.sprite.frame = 1
	target.z_index = 0


func update_speed(new_speed):
	weapon_speed = new_speed
	animator.speed_scale = weapon_speed


func draw():
	sprite.visible = true
	collision_shape.disabled = false


func sheathe():
	sprite.visible = false
	collision_shape.disabled = true


func _on_hit_box_body_entered(body):
	if body.is_in_group("Enemies"):
		body.hurt(collision_shape.position)
