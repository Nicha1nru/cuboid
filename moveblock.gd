extends StaticBody2D

@export var movement_distance: float = 100.0  # Movement distance in pixels
@export var speed: float = 100.0  # Movement speed in pixels per second
@export var direction: Vector2 = Vector2.RIGHT  # Direction of movement
@export var detection_radius: float = 200.0  # Radius to detect the player

var _start_position: Vector2
var _end_position: Vector2
var _moving_forward: bool = true
var _player_nearby: bool = false

# Reference to the detection area
@onready var detection_area: Area2D = $DetectionArea

func _ready():
	if detection_area == null:
		print("Error: DetectionArea not found!")
		return  # Exit if the DetectionArea is not found

	# Save the starting position and calculate the end position
	_start_position = global_position
	_end_position = _start_position + direction.normalized() * movement_distance

	# Connect to the area signals using Callable
	detection_area.connect("body_entered", Callable(self, "_on_body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_body_exited"))

func _process(delta: float):
	if _player_nearby:
		if _moving_forward:
			# Move towards the end position
			global_position = global_position.move_toward(_end_position, speed * delta)
			if global_position.distance_to(_end_position) < 0.1:
				_moving_forward = false
				_player_nearby = false
		else:
			# Move back towards the starting position
			global_position = global_position.move_toward(_start_position, speed * delta)
			if global_position.distance_to(_start_position) < 0.1:
				_moving_forward = true

# Signal handler when the player enters the detection area
func _on_body_entered(body):
	if body.is_in_group("player"):  # Ensure the body is the player
		_player_nearby = true
