class_name Projectile extends RigidBody2D

var is_moving : bool = false

@export var area : CollisionShape2D
@export var life : Timer

var base_stats : Dictionary = {
	#GameEnums.PROJECTILE.TARGET_POSITION : Vector2.ZERO,  ## Where to go.
	GameEnums.PROJECTILE.TARGET_ENTITY   : null,          ## Who to chase.
	GameEnums.PROJECTILE.TARGET_CHASE    : false,         ## Chase or not?
	GameEnums.PROJECTILE.LIFE_TIME       : 3,             ## Seconds.
	GameEnums.PROJECTILE.SIZE            : 5,             ## Scale (WARN - f'd CollisionShapes).
	GameEnums.STAT.MOVE_SPEED            : 400,           ## Base speed.
	GameEnums.STAT.DAMAGE                : 5,             ## Base damage.
} ## WARN - Will likely deprecate, use an array "effects" that imo should
## be iterated only once at the beginning (_ready) maybe.
## MIGHT NEED different arrays, one for effects that load once, other
## for effects that need constant updating like chasing an entity...

## TODO - Some projectiles, like fireballs, could start big, and lose size
## as they travel around, until they're gone (lifetime_timer == 0.0s)

## Can probably hold stats like target_seeking, bouncing, dupes, etc.
## OR create slots to attach scripts to. Slots that can be added
## or removed through skill trees or custom weapons...


func shoot(target: Vector2) -> void:
	# WARN TODO - It is not recommended to change velocity very often like this
	# Godot recommends using _integrate_forces, something like that, but maybe not needed here
	set_linear_velocity(global_position.direction_to(target) * base_stats[GameEnums.STAT.MOVE_SPEED])
	is_moving = true


func stop() -> void:
	set_linear_velocity(Vector2.ZERO)
	is_moving = false
