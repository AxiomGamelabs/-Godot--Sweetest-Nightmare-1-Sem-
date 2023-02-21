extends Button



func _on_button_up():
	var sfx = $buttonSfx
#	$buttonSfx/selfDestroyTimer.start()
	sfx.playing = true
	sfx.get_parent().remove_child(sfx)
	get_tree().root.add_child(sfx) #we make the sfx a child of the world, so it doesn't get queue freed with the pickup
