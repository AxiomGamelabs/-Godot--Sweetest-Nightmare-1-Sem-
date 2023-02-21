tool
extends Button

export(String, FILE) var nextScenePath = ""

func _on_button_up():
	
	playBtnSfx()
	
	#we use goToFatScene when we want to see the loadingScreen (i.e. when we have to load a "fat" scene
	if nextScenePath == "res://scenes/level1.tscn":
		deletePlayerBulletsAndPlayerPlatforms()
		sceneChanger.goToFatScene("res://scenes/level1.tscn", self)
		
	else:
		get_tree().change_scene(nextScenePath)


func deletePlayerBulletsAndPlayerPlatforms():
	#delete all nodes in the "playerBullets" group. (i.e. The ones that have the "playerBullets tag")
	for playerBullet in get_tree().get_nodes_in_group("playerBullets"):
		playerBullet.queue_free()
	#delete all nodes in the "playerPlatforms" group. (i.e. The ones that have the "playerPlatforms tag")
	for playerPlatform in get_tree().get_nodes_in_group("playerPlatforms"):
		playerPlatform.queue_free()
	#delete all nodes in the "playerPlatformDeathParticles" group
	for playerPlatformDeathParticles in get_tree().get_nodes_in_group("playerPlatformDeathParticles"):
		playerPlatformDeathParticles.queue_free()
	for playerPlatformDeathSfx in get_tree().get_nodes_in_group("playerPlatformDeathSfxs"):
		playerPlatformDeathSfx.queue_free()


func _on_mouse_entered():
	$hoverSfx.playing = true


func _get_configuration_warning():
	return "nextScenePath must be set for the button to work" if nextScenePath == "" else ""



func playBtnSfx():
	var sfx = $buttonSfx
	$buttonSfx/selfDestroyTimer.start()
	sfx.playing = true
	sfx.get_parent().remove_child(sfx)
	get_tree().root.add_child(sfx) #we make the sfx a child of the world, so it doesn't get queue freed with the pickup



func _on_selfDestroyTimer_timeout():
	queue_free()




