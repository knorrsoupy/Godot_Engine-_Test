extends Area2D

var screensize= Vector2.ZERO
# Called when the node enters the scene tree for the first time.

func _on_lifetime_timeout():
	queue_free()
	pass # Replace with function body.
