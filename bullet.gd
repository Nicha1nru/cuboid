extends Area2D

# Speed of movement
@export var speed: float = 200.0

@onready var _shoot_timer: Timer = Timer.new()

func _ready():
	# Use Callable to connect the signal in Godot 4
	self.area_entered.connect(_on_area_entered)

	# Set up the timer
	_shoot_timer.wait_time = 1.0
	_shoot_timer.autostart = true
	_shoot_timer.one_shot = false
	_shoot_timer.timeout.connect(self._on_shoot_timer_timeout)  # Signal setup
	add_child(_shoot_timer)

func _physics_process(delta: float) -> void:
	var target_position: Vector2 = get_nearest_player_position()
	if target_position != Vector2.ZERO:  # Check if we have a valid target
		var direction: Vector2 = (target_position - global_position).normalized()
		global_position += direction * speed * delta

func get_nearest_player_position() -> Vector2:
	var nearest_position: Vector2 = Vector2.ZERO
	var nearest_distance: float = INF
	for player in get_tree().get_nodes_in_group("player"):
		if player is Node2D:  # Ensure the node has a position
			var distance: float = global_position.distance_to(player.global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest_position = player.global_position
	return nearest_position

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		queue_free()  # Deletes this Area2D

func _on_shoot_timer_timeout():
	del()

func del():
	queue_free()
