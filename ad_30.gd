extends CharacterBody2D

# Movement distance in pixels
@export var movement_distance: float = 100.0
# Movement speed in pixels per second
@export var speed: float = 100.0
# Direction of movement (normalized Vector2)
@export var direction: Vector2 = Vector2.RIGHT

# Internal variables
var _start_position: Vector2
var _end_position: Vector2
var _moving_forward: bool = true

# Bullet scene and main node
@export var bullet = load("res://bullet.tscn")
var main = load("res://boss1.tscn")

# Timer for shooting
@onready var _shoot_timer: Timer = Timer.new()

@onready var audio_player = $song1
@onready var audio_player_2 = $song2
var last_position : float = -1.0  # To track the previous position

# Health and related variables
var health: int = 100

var song2 = false

func _ready():
	$song1.stream = load("res://sound/ad30_final1.mp3")
	$song1.play()

	# Save the starting position and calculate the end position
	_start_position = global_position
	_end_position = _start_position + direction.normalized() * movement_distance

	# Set up the timer
	_shoot_timer.wait_time = 3.0
	_shoot_timer.autostart = true
	_shoot_timer.one_shot = false
	_shoot_timer.timeout.connect(self._on_shoot_timer_timeout)  # Signal setup
	add_child(_shoot_timer)

	# Set up the Area2D signal connection (Godot 4 syntax)
	$Area2D.body_entered.connect(self._on_body_entered)

func _process(delta: float):
	if not audio_player.is_playing() and not song2:
		# Immediately start the second song when the first one ends
		song2 = true
		$song1.stream = load("res://sound/ad30_final2.mp3")
		$song1.play()

	if _moving_forward:
		# Move towards the end position
		global_position = global_position.move_toward(_end_position, speed * delta)
		if global_position.distance_to(_end_position) < 0.1:
			_moving_forward = false
	else:
		# Move back towards the starting position
		global_position = global_position.move_toward(_start_position, speed * delta)
		if global_position.distance_to(_start_position) < 0.1:
			_moving_forward = true

# Function to handle collisions with the "player" group
func _on_body_entered(body):
	if body.is_in_group("player"):
		health -= 50
		print("health: ", health)
		if health <= 0:
			phase2()

func _on_shoot_timer_timeout():
	shoot()

func shoot():
	$AnimationPlayer.play("new_animation")
	var projectile = bullet.instantiate()
	projectile.global_position = self.global_position
	get_tree().root.add_child(projectile)

# Phase 2 function that gets called when health reaches 0
func phase2():
	print("Health reached 0, transitioning to phase 2.")
	# You can implement phase 2 logic here

func _on_audio_1_finished():
	audio_player_2.play()
