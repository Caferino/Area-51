class_name Sword extends Node2D

signal attacked

var damage := 10
@onready var knockback_power : float = 100.0
@onready var sword_animator = $Sprite/Animator
@onready var collision_shape = $Sprite/HitBox/CollisionShape


func _input(_event):
	if Input.is_action_just_pressed("attack"):
		attack()


func attack():
	sword_animator.play("attack_left")
	attacked.emit()


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
