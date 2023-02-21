extends Node2D



func doubleJump():
	get_node("../../sprite").modulate = Color( 1, 1, 1, 1 ) #reset the sprite, so if we were hurt, and the hurt animation didn't got played to the end, the sprite doesn't stay red or invisible
	get_node("../..").jumpsMade += 1
	if get_node("../..").jumpsMade <= get_node("../..").maximumJumps:
		get_node("../..").velocity.y = -get_node("../..").doubleJumpStrength
	$doubleJumpSfx.playing = true
