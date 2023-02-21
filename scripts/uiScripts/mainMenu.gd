extends CanvasLayer

func _ready():
	#delete all nodes in the "levels" group. (i.e. The ones that have the "levels" tag)
	#we need this when we press "quit to main menu" btn from the pause- or victory-/defeat- Screens
	for level in get_tree().get_nodes_in_group("levels"):
		level.queue_free()



func _on_exitButton_mouse_entered():
	$mainMenu/buttonsContainer/exitButton/hoverBtnSfx.playing = true
