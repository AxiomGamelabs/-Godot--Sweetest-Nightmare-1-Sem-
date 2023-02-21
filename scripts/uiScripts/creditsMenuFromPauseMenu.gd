extends Control



func _on_creditsButton_button_up():
	self.visible = true
	get_node("../pauseMenu").visible = false


