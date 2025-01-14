extends Projectile

@export var explosion_area : CollisionShape2D
@export var fireball       : GPUParticles2D
@export var soot           : GPUParticles2D
@export var explosion      : GPUParticles2D

var LIFE_TIME   : float
var EX_AREA_RAD : float
var A_SHAPE_RAD : float
var F_SCALE_MIN : float
var F_SCALE_MAX : float
var S_SCALE_MIN : float
var S_SCALE_MAX : float
var E_SCALE_MIN : float
var E_SCALE_MAX : float


func _ready() -> void:
	LIFE_TIME   = base_stats[GameEnums.PROJECTILE.LIFE_TIME]
	EX_AREA_RAD = explosion_area.shape.radius
	A_SHAPE_RAD = area.shape.radius
	F_SCALE_MIN = fireball.process_material.scale_min
	F_SCALE_MAX = fireball.process_material.scale_max
	S_SCALE_MIN = soot.process_material.scale_min
	S_SCALE_MAX = soot.process_material.scale_max
	E_SCALE_MIN = explosion.process_material.scale_min
	E_SCALE_MAX = explosion.process_material.scale_max


func _process(_delta: float) -> void:
	if is_moving:
		var time_left                        = life.time_left
		explosion_area.shape.radius          = EX_AREA_RAD * time_left / LIFE_TIME
		area.shape.radius                    = A_SHAPE_RAD * time_left / LIFE_TIME
		fireball.process_material.scale_min  = F_SCALE_MIN * time_left / LIFE_TIME
		fireball.process_material.scale_max  = F_SCALE_MAX * time_left / LIFE_TIME
		soot.process_material.scale_min      = S_SCALE_MIN * time_left / LIFE_TIME
		soot.process_material.scale_max      = S_SCALE_MAX * time_left / LIFE_TIME
		explosion.process_material.scale_min = E_SCALE_MIN * time_left / LIFE_TIME
		explosion.process_material.scale_max = E_SCALE_MAX * time_left / LIFE_TIME


func explode():
	life.stop()
	fireball.emitting = false
	explosion.emitting = true
	
	## TODO - Apply damage to all bodies colliding with explosion_area ONCE


func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	stop()
	explode()


func _on_explosion_finished() -> void:
	queue_free()
