extends Node2D


func drown():
	get_node("../../sprite").modulate = Color( 1, 1, 1, 1 ) #reset the sprite, so if we were hurt, and the hurt animation didn't got played to the end, the sprite doesn't stay red or invisible
	$drowningSfx.playing = true
