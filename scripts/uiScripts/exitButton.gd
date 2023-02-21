extends Button



func _on_button_up():
	$buttonSfx.playing = true
	get_tree().quit()
