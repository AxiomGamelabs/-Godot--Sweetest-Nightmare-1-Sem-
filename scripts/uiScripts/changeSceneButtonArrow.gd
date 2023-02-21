tool
extends TextureButton


export(String, FILE) var nextScenePath = ""

func _on_button_up():
	get_tree().paused = false
	
	var sfx = $buttonSfx
	$buttonSfx/selfDestroyTimer.start()
	sfx.playing = true
	sfx.get_parent().remove_child(sfx)
	get_tree().root.add_child(sfx) #we make the sfx a child of the world, so it doesn't get queue freed with the pickup
	
	
	get_tree().change_scene(nextScenePath)


func _get_configuration_warning():
	return "nextScenePath must be set for the button to work" if nextScenePath == "" else ""




func _on_selfDestroyTimer_timeout():
	queue_free()


func _on_backToMainMenuButtonArrow_mouse_entered():
	$hoverBtnSfx.playing = true
