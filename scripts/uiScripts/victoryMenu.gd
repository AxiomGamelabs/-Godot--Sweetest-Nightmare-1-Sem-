extends Control



func setVisible():
	get_node("../../playableLayer/player").youWon = true
	playJingle()
	get_tree().paused = true
	self.visible = true
	
func playJingle():
	var sfx = $victoryJingle
	sfx.playing = true
#	sfx.get_parent().remove_child(sfx)
#	get_tree().root.add_child(sfx) #we make the sfx a child of the world, so it doesn't get queue freed with the playerPlatform
#



