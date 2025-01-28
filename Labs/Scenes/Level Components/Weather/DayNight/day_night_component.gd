extends CanvasModulate
## [Color=yellow]Day [Color=purple]Night [Color=white]Cycle

@export var cycle : GradientTexture1D


func _ready() -> void:
	visible = true  ## Just so I can hide it in the Inspector and not have everything dark


func _process(delta: float) -> void:
	## TODO WARN - Fix this get_parent... Maybe INGAME_TO... and time should be stats, like a human's
	## and probably accessible and updated in realtime in a lightweight way inside a dictionary
	## to access with StringNames declared in GameEnums for performance.
	var value = (sin(get_parent().get_parent().time.current_time - PI / 2) + 1.0) / 2.0
	self.color = cycle.gradient.sample(value)
