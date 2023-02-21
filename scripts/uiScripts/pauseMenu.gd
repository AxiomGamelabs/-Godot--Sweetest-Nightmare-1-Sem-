extends Control

var isPaused = false setget setIsPaused


func _unhandled_input(event):
	var defeatMenuIsNotActive = get_node("../../playableLayer/player").isDead == false
	var victoryMenuIsNotActive = get_node("../../playableLayer/player").youWon == false
	var loadingScreenIsNotActive = get_tree().root.get_node("loadingScreen") == null
	
#	if event.is_action_pressed("pause") and get_node("../../playableLayer/player").isDead == false and get_node("../../playableLayer/player").isDead == false and get_node("../../playableLayer/player").youWon == false and get_tree().root.get_node("loadingScreen") == null: #we don't want to be able to activate the pause menu, while the defeatMenu, winningMenu or loadingScreen are active
	if event.is_action_pressed("pause") and defeatMenuIsNotActive and victoryMenuIsNotActive and loadingScreenIsNotActive: #we don't want to be able to activate the pause menu, while the defeatMenu, winningMenu or loadingScreen are active
#		print("LoadingScreen is in tree? (i.e. when we search for it we find something not equal null)" + str(get_tree().root.get_node("loadingScreen") != null))
		
		self.isPaused = !isPaused
		if(get_node("../settingsMenuFromPauseMenu").visible == true):
			get_node("../settingsMenuFromPauseMenu").visible = false
	
	
	
func setIsPaused(value):
	isPaused = value
	get_tree().paused = isPaused
	visible = isPaused #the pause menu is by default "not visible"


func _on_button_up():
	self.isPaused = false
	$clickBtnSfx.playing = true
	



func _on_pauseButton_button_up(): #the one in the hud
	self.isPaused = true
#	$clickBtnSfx.playing = true




func _on_pauseButtonTopRx_button_up(): #the one in the pause menu
	self.isPaused = false
	get_node("../settingsMenuFromPauseMenu").visible = false
	$clickBtnSfx.playing = true

func _on_pauseButtonTopRx_mouse_entered():
	$hoverBtnSfx.playing = true



func _on_backButtonArrow_button_up():
	self.visible = true
	get_node("../settingsMenuFromPauseMenu").visible = false


func _on_settingsButton_mouse_entered():
	$hoverBtnSfx.playing = true


func _on_resumeButton_mouse_entered():
	$hoverBtnSfx.playing = true



