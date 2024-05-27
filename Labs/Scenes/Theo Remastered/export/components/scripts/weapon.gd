class_name Weapon extends Node

@export var animator        : AnimationPlayer
@export var sprite          : Sprite2D
@export var area            : Area2D

var attack_stats = {
	GameEnums.ATTACK_STATS.WEAPON_SPEED      :   2,      # speed_scale = [-4, 4] in Godot
	GameEnums.ATTACK_STATS.WEAPON_DAMAGE     :  10,
	GameEnums.ATTACK_STATS.KNOCKBACK_POWER   : 100
}


