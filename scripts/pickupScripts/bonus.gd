extends Area2D




func _on_bonus_body_entered(body):
	if body.has_method("collideWithBonus"):
		body.collideWithBonus()
			
		var sfx = $collectBonusSfx
		$collectBonusSfx/selfDestroyTimer.start()
		sfx.playing = true
		sfx.get_parent().remove_child(sfx)
		get_tree().root.add_child(sfx) #we make the sfx a child of the world, so it doesn't get queue freed with the pickup

		queue_free()
