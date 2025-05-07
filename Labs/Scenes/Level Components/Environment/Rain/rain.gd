class_name Rain extends Area2D
## An area where it's raining.

@onready var tot_radius : int = $CollisionShape.shape.radius  ## This rain area's total radius.
@onready var inner_area : int = tot_radius / 3 * 2            ## 2/3 of the total area.
@export  var rain_str   : int = 64                            ## GPUParticle2D's amount emitted.

var rain   : GPUParticles2D  = null                           ## The player's rain/weather UI
var inside : bool = false                                     ## Is the player inside this area?


func _ready():
	# Disable process at the start, so it's not running every frame.
	set_process(false)                    ## Just found out about this beautiful function.
	tot_radius = tot_radius * tot_radius  ## Using distance_squared_to is faster, so.
	inner_area = inner_area * inner_area  ## Using distance_squared_to is faster, so.
	rain = Caferino.player.controller.camera_base.rain


func _process(_delta: float) -> void:
	if inside:
		var curr_pos = rain.global_position.distance_squared_to(self.global_position)
		if curr_pos > inner_area:
			rain.amount = int(rain_str - (rain_str * ((curr_pos - inner_area) / (tot_radius - inner_area))))
		else:
			rain.amount = rain_str


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		inside = true
		rain.emitting = true
		set_process(true)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		inside = false
		rain.emitting = false
		set_process(false)
