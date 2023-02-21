extends Control


func _ready():
	displayRealAudioValues()



func displayRealAudioValues():
	$uiElements/ui/musicVolume.value = AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("music")
	)


func _input(event):
	if event.is_action_pressed("jump"):
		loadMainMenu()



func loadMainMenu():
	get_tree().change_scene("res://scenes/uiScenes/menuScenes/mainMenu.tscn")


func _on_logoIntro_finished():
	$logoIntro.visible = false
	$cutSceneIntro.visible = true
	$cutSceneIntro.play()
	


func _on_cutSceneIntro_finished():
	loadMainMenu()




func _on_musicVolume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), value)
