extends StaticBody2D


const playerPlatformDeathTogetherParticleVfxScene = preload("res://scenes/particleEffectsScenes/playerPlatformDeathTogetherParticleVfx.tscn")


func _ready():
	$animationPlayer.play("countdown")
	

func _on_SelfDestroyTimer_timeout():
	spawnPlayerPlatformDeathTogetherParticleVfx()
	
	playPlatformDeathSfx()

	queue_free()


func playPlatformDeathSfx():
	var sfx = $platformDeathSfx
	$platformDeathSfx/selfDestroyTimer.start()
	sfx.playing = true
	sfx.get_parent().remove_child(sfx)
	get_tree().root.add_child(sfx) #we make the sfx a child of the world, so it doesn't get queue freed with the playerPlatform
	

func spawnPlayerPlatformDeathTogetherParticleVfx():
	var playerPlatformDeathTogetherParticleVfx = playerPlatformDeathTogetherParticleVfxScene.instance()
	get_tree().root.add_child(playerPlatformDeathTogetherParticleVfx) #we make the particle vfx a child of the world, so it doesn't get queue freed together with the platform
	playerPlatformDeathTogetherParticleVfx.global_position = position



func _on_trapDetectArea2D_body_entered(body):
	if body.has_method("collideWithPlayerPlatform"):
		spawnPlayerPlatformDeathTogetherParticleVfx()
		
		playPlatformDeathSfx()
	
		queue_free()


func _on_playerDetectArea2DLx_body_entered(body):
	if body.has_method("standOnMiniPlatformLxPart"):
		body.standOnMiniPlatformLxPart() #so dass der player ausrutscht


func _on_playerDetectArea2DRx_body_entered(body):
	if body.has_method("standOnMiniPlatformRxPart"):
		body.standOnMiniPlatformRxPart() #so dass der player ausrutscht


func _on_playerExitDetectArea2D_body_exited(body): #this functions stops the player from slipping
	if body.has_method("exitMiniPlatform"):
		body.exitMiniPlatform() #so that player doesnt slips away anymore


