extends CharacterBody3D

# Variables for movement and jump
var speed = 5
var jump_force = 10

@onready var ai_controller: Node3D = $AIController3D

# Called every frame
func _process(_delta):
	# Check for manual input and move the cube
	# handle_input()
	# AI Movement Controller
	ai_movement_controller()
	# Move the cube based on the velocity
	move_and_slide()


# Function to handle user input
func handle_input():
	# Get the input vector
	var input_vector = Vector3()

	# Check for movement input
	if Input.is_action_pressed("MOVE_RIGHT"):
		input_vector.x += 1
	if Input.is_action_pressed("MOVE_LEFT"):
		input_vector.x -= 1
	if Input.is_action_pressed("MOVE_UP"):
		input_vector.z -= 1
	if Input.is_action_pressed("MOVE_DOWN"):
		input_vector.z += 1

	# Normalize the input vector to avoid faster movement diagonally
	input_vector = input_vector.normalized()

	# Move the cube
	velocity.x = input_vector.x * speed
	velocity.z = input_vector.z * speed

	# Check for jump input
	if Input.is_action_just_pressed("JUMP"):
		jump()
	
	# Apply gravity
	apply_gravity()


func ai_movement_controller():
	velocity.x = ai_controller.move.x
	velocity.z = ai_controller.move.y


# Function to make the cube jump
func jump():
	# Check if the cube is on the ground (you might need to adjust this based on your scene)
	if is_on_floor():
		# Apply the jump force
		velocity.y = jump_force


# Function to apply gravity
func apply_gravity():
	# If the cube is not on the ground, apply gravity
	if not is_on_floor():
		velocity.y += get_physics_process_delta_time() * (-19.6)  # Adjust gravity as needed


func _on_target_body_entered(_body):
	position = Vector3(1.789, 0.888, -1.685)
	ai_controller.reward += 1.0


func _on_wall_body_entered(_body):
	position = Vector3(1.789, 0.888, -1.685)
	ai_controller.reward -= 1.0
	ai_controller.reset()
	
