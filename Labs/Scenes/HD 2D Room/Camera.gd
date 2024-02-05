extends Camera3D

const LERP_SPEED = 1
var moving = false

@onready var target = $Shoulder
@onready var original = $"Original Position"

func _process(_delta):
	if moving:
		var tween = create_tween()
		tween.tween_property(self, "position", target.position, 1).set_ease(Tween.EASE_IN_OUT)
	else:
		var tween = create_tween()
		tween.tween_property(self, "position", original.position, 1).set_ease(Tween.EASE_IN_OUT)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("attack"):  # Replace with your desired input action
			moving = true
		elif event.is_action_released("attack"):
			moving = false
