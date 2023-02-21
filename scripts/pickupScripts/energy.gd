extends Area2D


#signal displayFullEnergyMsgSignal


func _on_energy_body_entered(body):
	if body.has_method("collideWithEnergy"):
		body.collideWithEnergy()
		if(body.weCanDeleteEnergyPickupWeJustCollidedWith): #we cannot collect energy if we are at full energy
			body.weCanDeleteEnergyPickupWeJustCollidedWith = false
			
			var sfx = $collectEnergySfx
			$collectEnergySfx/selfDestroyTimer.start()
			sfx.playing = true
			sfx.get_parent().remove_child(sfx)
			get_tree().root.add_child(sfx) #we make the sfx a child of the world, so it doesn't get queue freed with the pickup
			
			queue_free()
		else:
			#we get the first element in the levels group (at the first run it is named "level1" but if you restart the level it could be named "@level1@86" so relative paths with "level1" would crash the game
			get_tree().get_nodes_in_group("levels")[0].get_node("gui/hud/messages/youAreFullEnergyMsg").visible = true
			get_tree().get_nodes_in_group("levels")[0].get_node("gui/hud/messages/youAreFullEnergyMsg/setEnergyMsgInvisibleAgainTimer").start() #activate the invisibility timer as well
			
			
#			emit_signal("displayFullEnergyMsgSignal")
