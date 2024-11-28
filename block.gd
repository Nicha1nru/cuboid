extends Node2D  # Use Node3D if in 3D

# Variables
@export var disappear_time: float = 2.0  # Time after collision to disappear

func _on_body_entered(body):
	if body.name == "Player":  # Replace "Player" with your player node's name or type check
		print("Player collided with block")
		# Wait and then queue_free
		await get_tree().create_timer(2).timeout
		queue_free()
