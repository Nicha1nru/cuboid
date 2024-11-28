extends Area2D

func disable_collision():
	if $StaticBody2D/CollisionShape2D:
		$StaticBody2D/CollisionShape2D.queue_free()
		$Sprite2D.texture = null
