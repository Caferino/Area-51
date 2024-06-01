class_name Camera extends Node2D
## The alcarodian [color=cyan]camera.

@export var controller  : PlayerControllerComponent             ## The Player's controller.

# It is bad practice to reuse tweens
@onready var tween      : Tween    = create_tween()             ## Animates the camera's movement.
const zoom_speed        : Vector2  = Vector2(1, 1)              ## Zoom in/out speed.
const drag_dist         : float    =  500.0                     ## The camera's dragging distance allowed.
var dragging            : bool     = false                      ## Is the camera currently being dragged?
# For the camera's breathing effect
const min_x             : float    =  -3.0                      ## Minimum x coordinate it will touch.
const max_x             : float    =   3.0                      ## Maximum x coordinate it will touch.
const min_y             : float    =  -3.0                      ## Minimum y coordinate it will touch.
const max_y             : float    =   3.0                      ## Maximum y coordinate it will touch.
var breathing_in        : bool     = false                      ## Saves the current "breathing" state.
var random_x            : float    = randf_range(min_x, max_x)  ## Random x coordinate for the bounce.
var random_y            : float    = randf_range(0, max_y)      ## Random y coordinate for the bounce.


## Starts by holding the camera.
func _ready():
	hold_camera()


## Reads the given zoom-in/out input from the player and whether the screen is being dragged.
func _input(_event: InputEvent):
	if Input.is_action_pressed("zoom_in"):
		self.zoom = clamp(self.zoom + zoom_speed, Vector2(2, 2), Vector2(10,10))
	if Input.is_action_pressed("zoom_out"):
		self.zoom = clamp(self.zoom - zoom_speed, Vector2(2, 2), Vector2(10,10))
	if Input.is_action_pressed("drag_camera"):
		start_dragging()
	elif Input.is_action_just_released("drag_camera"):
		stop_dragging()


## Moves the camera to the given held mouse position.
## TODO - Be able to drag around within a limited view distance.
func start_dragging():
	#if !dragging:
	if !get_parent().get_parent().is_moving:
		print("dragging!")
		dragging = true
		
		## TODO - Maybe, instead of hiding it, switch the cursor with an eye icon
		## It kinda feels better being able to see the cursor
		#if Input.get_mouse_mode() != Input.MOUSE_MODE_CONFINED_HIDDEN:
			#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
		
		tween.kill()
		var direction = get_parent().global_position.direction_to(get_global_mouse_position())
		
		## TODO - Can the movement feel slower and smoother? My cursor speed is too fast
		## TODO - In the future, test this feature with different screen sizes. That might hurt.
		if get_parent().global_position.distance_to(get_global_mouse_position()) <= drag_dist:
			tween = create_tween()
			tween.connect("finished", breath)
			tween.tween_property(self, "position", get_parent().to_local(get_global_mouse_position()), 0.05).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
			tween.play()
		else:
			position = clamp(direction * drag_dist, Vector2(-drag_dist, -drag_dist), Vector2(drag_dist, drag_dist))
			
			
		#position = clamp(direction * drag_dist, Vector2(-50, -50), Vector2(50, 50))
		#position = clamp(get_global_mouse_position() - get_parent().global_position, Vector2(-50, -50), Vector2(50, 50))0
		#tween.kill()
		#tween = create_tween()
		##tween.connect("finished", breath)
		#tween.tween_property(self, "position", clamp(get_parent().to_local(get_global_mouse_position()), Vector2(-150, -150), Vector2(150, 150)), 0)#.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
		#tween.play()
		
		## ! DEBUGGER
		print("----------------------------------------")
		print("From Parent's position = ", get_parent().position)
		print("To Mouse's global position = ", get_global_mouse_position())
		print("Direction = ", direction)
		print("Direction * Speed = ", direction * drag_dist)
		print("Distance = ", get_parent().global_position.distance_to(get_global_mouse_position()))
		print("Angle = ", get_parent().position.angle_to(get_global_mouse_position()))
		print("Difference = ", get_global_mouse_position() - get_parent().global_position)
		print("Made local = ", get_parent().to_local(get_global_mouse_position()))
		print("Final position = ", clamp(direction * drag_dist, Vector2(-50, -50), Vector2(50, 50)))
		print("Final position = ", position)
		print("----------------------------------------")
		
		#tween.kill()
		#tween = create_tween()
		#tween.connect("finished", breath)
		#tween.tween_property(self, "global_position", get_global_mouse_position(), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
		#tween.play()
	
	
	## Old but good, dont delete
	#if controller.is_moving == false:
		#if Input.get_mouse_mode() != Input.MOUSE_MODE_CONFINED_HIDDEN:
			#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
		#
		#if !dragging:
			#dragging = true
			#
			#tween.kill()
			#tween = create_tween()
			#tween.connect("finished", breath)
			#tween.tween_property(self, "global_position", get_global_mouse_position(), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
			#tween.play()


## Stops the camera dragging, returning it to its origin point instantly.
func stop_dragging():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	position = get_parent().position
	dragging = false
	hold_camera()


## Simulates a handheld effect by using tweens.
func hold_camera():
	if !dragging:
		tween.kill()
		tween = create_tween()
		tween.connect("finished", breath)
		tween.tween_property(self, "position", Vector2(random_x, random_y), 6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD).set_delay(randf_range(0.001, 0.2))
		tween.play()


## Complimentary method for the handheld effect.
## Bounces the camera up and down within a space and a short pause.
## Runs everytime the tween finishes its animation.
func breath():
	if !dragging:
		random_x = randf_range(min_x, max_x)
		if breathing_in : random_y = randf_range(min_y, 0)
		else            : random_y = randf_range(0, max_y)
		breathing_in = !breathing_in
		hold_camera()
