extends Area2D

@export var target : Area2D

func on_body_entered(body):
	if body.name == "Player":
		target.disable_collision()
		$Sprite2D.texture = load("res://sprites/lever2.png")
		print("print money print")

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		target.disable_collision()
		$Sprite2D.texture = load("res://sprites/lever2.png")
		print("print money print")
