class_name LightSource extends Marker2D

@export var color    : Color = Color("#ffefc4")   ## Midnight tint, darkness, night.
@export var radius   : float = 64.0               ## The circular area the light covers.
@export var strength : float =  1.0               ## Useful to add muddy effects.
@export var flick_st : float =  0.02              ## Flicker strength.
@export var flick_sp : float =  1.5                 ## Flicker speed.
@export var flick_dr : float =  0.15              ## Flicker duration.
@onready var tween   : Tween = create_tween().set_parallel(true)  ## Animates the flicker effect.


func _ready() -> void:
	flicker()


func flicker() -> void:
	# NOTE - Must kill and create_tween everytime, or we get Orphan Tweeners overtime
	tween.kill()
	tween = create_tween().set_parallel(true)
	tween.finished.connect(flicker)
	tween.tween_property(self, "strength", strength + flick_st, flick_dr)
	tween.tween_property(self, "radius", radius + flick_sp, flick_dr)
	tween.play()
	flick_st *= -1
	flick_sp *= -1
