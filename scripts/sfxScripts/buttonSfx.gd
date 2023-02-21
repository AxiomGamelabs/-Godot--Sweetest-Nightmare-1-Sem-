extends AudioStreamPlayer



func _on_selfDestroyTimer_timeout():
	queue_free()
