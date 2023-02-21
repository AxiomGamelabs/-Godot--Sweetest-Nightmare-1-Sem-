extends KinematicBody2D


var velocity
export (int) var speed = 300

const playerPlatformDeathTogetherParticleVfxScene = preload("res://scenes/particleEffectsScenes/playerPlatformDeathTogetherParticleVfx.tscn")




func _physics_process(delta):
	var collisionInfo = move_and_collide(velocity.normalized() * delta * speed)




func spawnPlayerPlatformDeathTogetherParticleVfx():
	var playerPlatformDeathTogetherParticleVfx = playerPlatformDeathTogetherParticleVfxScene.instance()
	get_tree().root.add_child(playerPlatformDeathTogetherParticleVfx) #we make the particle vfx a child of the world, so it doesn't get queue freed together with the platform
	playerPlatformDeathTogetherParticleVfx.global_position = position


func _on_detectEnvironmentAndTrapsArea2D_body_entered(body):
#	if body.has_method("collideWithPlayerBullet"):
#		body.collideWithPlayerBullet()
	spawnPlayerPlatformDeathTogetherParticleVfx()
	queue_free()


func _on_selfDestroyTimer_timeout():
	#spawn the platformDeathParticleVfx
	spawnPlayerPlatformDeathTogetherParticleVfx()	
	queue_free()



