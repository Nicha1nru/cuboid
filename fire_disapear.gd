extends Node2D

@export var time : float
@export var time2 : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	do() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func do():
	$AnimationPlayer.play("fire")
	await get_tree().create_timer(time).timeout
	$Area2D/CollisionShape2D.set_disabled(true)
	$Sprite2D.texture = null
	await get_tree().create_timer(time2).timeout
	$Area2D/CollisionShape2D.set_disabled(false)
	$Sprite2D.texture = load("res://sprites/fire.png")
	do()
