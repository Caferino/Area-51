class_name FireballSpell extends Projectile
## A strong red & green spell.

## WARNING NOTE - To create bouncy fireballs, frozen fireballs, slimy, etc,
## I have two ways: use variables like right now, or, maybe better, create
## them as scrips, slimy_fireball_spell.gd, extends this class FireballSpell,
## and override fireball_spell.gd's necessary methods and properties there.

## WARNING NOTE - The heatwave Sprite2D, for some weird reason, must have a
## high z-index, like 10 or more, because, it it's lower than other visuals,
## the particles and the shader start blinking, things breaks, it's weird.

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


## Diminishes its size over its lifetime left.
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


## Stop the lifetime timer to rely on the explosion's animation finished() signal.
func explode():
	life.stop()
	$AnimationPlayer.play("Red Spells/fireball_explosion")
	
	## TODO - Apply damage to all bodies colliding with explosion_area ONCE


## Collision with CollisionShapes.
func _on_body_entered(body: Node) -> void:
	stop()
	explode()


## If it collides and explodes, wait for the animation to finish before freeing.
func _on_explosion_finished() -> void:
	queue_free()


## If it takes too long to collide, free it.
func _on_timer_timeout() -> void:
	queue_free()
