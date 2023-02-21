extends Control



func _ready():
	displayRealAudioValues()



func displayRealAudioValues():
	$slidersContainer/musicVolume.value = AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("music")
	)
	$slidersContainer/sfxVolume.value = AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("sfx")
	)
	$slidersContainer/uiVolume.value = AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("ui")
	)


func _on_masterVolume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)




func _on_musicVolume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), value)


func _on_sfxVolume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), value)


func _on_uiVolume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("ui"), value)
	
	
	

func _on_settingsButton_button_up():
	self.visible = true
	displayRealAudioValues()
	get_node("../pauseMenu").visible = false
	$clickBtnSfx.playing = true





func _on_backButtonArrow_mouse_entered():
	$hoverBtnSfx.playing = true


func _on_backButtonArrow_button_up():
	$clickBtnSfx.playing = true


func _on_pauseButtonTopRx_mouse_entered():
	$hoverBtnSfx.playing = true
