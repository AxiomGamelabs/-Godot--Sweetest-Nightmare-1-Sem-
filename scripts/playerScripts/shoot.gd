extends Node2D

const playerBulletScene = preload("res://scenes/playerScenes/playerBullet.tscn")
var currentBullet

const playerPlatformDeathTogetherParticleVfxScene = preload("res://scenes/particleEffectsScenes/playerPlatformDeathTogetherParticleVfx.tscn")


func _physics_process(delta):
	$bulletSpawnRotator.look_at(get_global_mouse_position()) 


func shoot():
	#delete all nodes in the "playerBullets" group. (i.e. The ones that have the "playerBullets" tag)
	for playerBullet in get_tree().get_nodes_in_group("playerBullets"):
		spawnPlayerPlatformDeathTogetherParticleVfx(playerBullet)
		playerBullet.queue_free()
	
	currentBullet = playerBulletScene.instance()
	$shootSfx.playing = true
	
#	add_child(currentBullet) #like this the bullet would move together with the player
	get_tree().root.add_child(currentBullet) #we make the bullet a child of the Level
#	currentBullet.position = $BulletSpawnPoint.position #this will not work, we do not see the bullet
	currentBullet.position = $bulletSpawnRotator/bulletSpawnPoint.global_position #child 0 is the BulletSpawnPoint node
	currentBullet.velocity = get_global_mouse_position() - currentBullet.position
	

func spawnPlayerPlatformDeathTogetherParticleVfx(playerBullet):
	var playerPlatformDeathTogetherParticleVfx = playerPlatformDeathTogetherParticleVfxScene.instance()
	get_tree().root.add_child(playerPlatformDeathTogetherParticleVfx) #we make the particle vfx a child of the world, so it doesn't get queue freed together with the platform
	playerPlatformDeathTogetherParticleVfx.global_position = playerBullet.position

##############






