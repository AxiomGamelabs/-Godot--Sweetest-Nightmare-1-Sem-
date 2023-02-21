extends Particles2D



func _on_selfDestroyTimer_timeout():
	queue_free()
