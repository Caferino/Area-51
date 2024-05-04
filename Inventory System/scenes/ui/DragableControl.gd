class_name DragableControl extends ScaleControl

@export var safe_zone: int = 30

var dragging: bool = false
var offset: Vector2


func _ready():
	super()   # Calls ScaleControl._init()
	get_viewport().size_changed.connect(_on_size_changed)


func _input(event):
	if event is InputEventMouse and dragging:
		set_pos(event.position - offset)


func set_ui_scale(value):
	super(value)
	await get_tree().process_frame
	set_pos(position)


func set_pos(pos):
	var scaled_size = size * scale
	var screen_size = get_viewport().get_visible_rect().size
	pos.x = clamp(pos.x, -scaled_size.x + safe_zone, screen_size.x - safe_zone)
	pos.y = clamp(pos.y, -scaled_size.y + safe_zone, screen_size.y - safe_zone)
	position = pos


func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		offset = get_global_mouse_position() - position
		dragging = event.pressed
		move_to_front()


func _on_size_changed():
	set_pos(position)
