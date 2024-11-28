extends CharacterBody2D

var SPEED = 300.0
var launch_speed = 600.0
const JUMP_VELOCITY = -300.0
const HOP_ACCELERATION = 1.3
const TIME_LIMIT = 0.1  # Time limit between jumps (0.4 seconds for quicker timing)

var hop_acc = 1.0
var last_jump_time = -TIME_LIMIT  # Set to allow immediate jump at start
var hop_timer = 0.0  # Timer for controlling the hop time window
var jump_direction = 0  # Tracks the direction of movement during jump

@export var bullet: PackedScene

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta
		hop_timer = 0  # Reset hop timer while in the air
	else:
		# Update hop timer when on the floor
		hop_timer += delta

	# Handle jump logic
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		# If jump is pressed within TIME_LIMIT seconds after the last jump
		if hop_timer <= TIME_LIMIT and jump_direction != 0:
			hop_acc *= HOP_ACCELERATION  # Accelerate speed
			print("+bunny hop")
		else:
			hop_acc = 1  # Reset speed acceleration
			SPEED = 300.0
			print("no bunny hop")
			jump_direction = 0  # Reset jump direction

		# Perform the jump
		velocity.y = JUMP_VELOCITY
		last_jump_time = 0  # Reset jump time

	# Get movement input and handle the horizontal velocity
	var direction := Input.get_axis("a", "d")

	if direction != 0:
		# Track the direction the player is moving (left or right) during the jump
		if jump_direction == 0:
			jump_direction = sign(direction)  # Store the initial direction
		# If direction changes, reset the hop
		elif sign(direction) != jump_direction:
			hop_acc = 1  # Reset hop acceleration if direction changes
			print("Direction change, hop reset")
			jump_direction = 0

		velocity.x = direction * (SPEED * hop_acc)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("hi")
	if area.is_in_group("kill"):
		print("dead")
		get_tree().reload_current_scene()
	elif area.is_in_group("finish"):
		print("finish")
		get_tree().change_scene_to_file("res://levels/level2.tscn")
	elif area.is_in_group("ad30"):
		# Launch the node upwards
		velocity.y = -launch_speed  # Apply an upward force (negative y direction)
		print("Launched upwards due to ad30 collision")
