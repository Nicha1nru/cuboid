extends Area2D

@export var target : StaticBody2D

func on_area_one_touched(body):
	if body.is_in_group("player"):
		target.disable_collision()
		print("disabled")
