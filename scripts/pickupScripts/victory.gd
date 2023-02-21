extends Area2D



func _on_victory_body_entered(body):
	get_node("../../platforms/finalClock/animationPlayer").play("finalClockAnimation")
	var finalClockRingSfx = get_node("../../platforms/finalClock/clockRingSfx")
	finalClockRingSfx.playing = true
	get_node("../../../player").youWon = true
	
