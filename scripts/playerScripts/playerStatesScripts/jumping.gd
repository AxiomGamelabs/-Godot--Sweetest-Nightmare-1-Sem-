extends Node2D


func jump():
	get_node("../../sprite").modulate = Color( 1, 1, 1, 1 ) #reset the sprite, so if we were hurt, and the hurt animation didn't got played to the end, the sprite doesn't stay red or invisible
	get_node("../..").jumpsMade += 1
	get_node("../..").velocity.y = -get_node("../..").jumpStrength
	$jumpSfx.playing = true 
