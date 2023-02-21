extends KinematicBody2D



export var speed = 550

export var jumpStrength = 750
var jumpsMade = 0
export var maximumJumps = 2

export var doubleJumpStrength = 800
export var gravity = 2000


var velocity = Vector2.ZERO #current velocity

var isDrowning = false
var isDying = false
var isDead = false
var youWon = false

export var maxPlayerPlatformsAtSameTime = 2

var isStandingOnMiniPlatform = false
export var slipperyFactorOnMiniPlatform = 50
export var slipperyFactorOnYellowTrap = 150

var slipDirection #can be -1 (lx) or +1 (rx)

var isStandingOnYellowTrap = false

var isHoveringPauseBtn = false #we don't want to shoot a bubble when clicking on the pause btn

var isAtFullEnergy = true
var weCanDeleteEnergyPickupWeJustCollidedWith = false
var weCanDeleteHealthPickupWeJustCollidedWith = false 
 

onready var hud = get_node("../../gui/hud")
onready var defeatMenu = get_node("../../gui/defeatMenu")



######"CONNECTIONS" MIT DEM AUTOLOADSCRIPT###########
#Die autoload datei ist geschrieben worden, weil wir schon den code für "level switching" vorbereiten wollen, und uns stats zwischen den levels "merken" wollen.
#diese variablen brauchen wir, damit in den if abfragen nicht immer myAutoloadScript.playerEnergy schreiben müssen, sonder "energy". Das macht den code lesbarer
#wenn sich diese werte ändern gibt es immer 2 schritte: der wert im player script (energy, health oder bulletIsFlying) muss geändert werden und dann muss der wert in der autoload datei geändert werden, damit es die hud ablesen kann
var energy = myAutoloadScript.playerEnergy
var health = myAutoloadScript.playerHealth
var bonus = myAutoloadScript.playerBonus
####################################################



onready var animationTree = $animationTree
onready var animationState = animationTree.get("parameters/playback")

onready var idlingState = get_node("states/idling")
onready var runningState = get_node("states/running")
onready var jumpingState = get_node("states/jumping")
onready var doubleJumpingState = get_node("states/doubleJumping")
onready var fallingState = get_node("states/falling")
onready var slidingState = get_node("states/sliding")
onready var drowningState = get_node("states/drowning")
onready var dyingState = get_node("states/dying")
onready var winningState = get_node("states/winning")





const playerPlatform5Scene = preload("res://scenes/playerScenes/playerPlatformScenes/playerPlatform5.tscn")
const playerPlatform4Scene = preload("res://scenes/playerScenes/playerPlatformScenes/playerPlatform4.tscn")
const playerPlatform3Scene = preload("res://scenes/playerScenes/playerPlatformScenes/playerPlatform3.tscn")
const playerPlatform2Scene = preload("res://scenes/playerScenes/playerPlatformScenes/playerPlatform2.tscn")
const playerPlatform1Scene = preload("res://scenes/playerScenes/playerPlatformScenes/playerPlatform1.tscn")

const playerPlatformDeathTogetherParticleVfxScene = preload("res://scenes/particleEffectsScenes/playerPlatformDeathTogetherParticleVfx.tscn")
const bloodParticleVfxScene = preload("res://scenes/particleEffectsScenes/bloodParticleVfx.tscn")



#######IDEE: Der player befindet sich immer in genau einer der folgenden states: (Ground States): idling, running (Air States): jumping, doubleJumping, falling################
#######Der spieler kann dann aus jeder dieser "states" entweder schießen oder platform spawnen
enum playerState {
	idling,
	running,
	jumping,
	doubleJumping,
	falling,
	sliding,
	drowning,
	dying,
	winning
}

var currentState = playerState.idling





func _ready():
	playerReset()


######################################
func _physics_process(delta):
	updatePlayerState()
	
#	print(str(currentState) + str(isDrowning)) #DEBUG LINE
#	print(get_tree().get_nodes_in_group ("playerBullets"))
#	print(get_tree().get_nodes_in_group ("playerPlatforms"))

	
	
	var isShooting = Input.is_action_just_pressed("shoot") && !isHoveringPauseBtn
	var isSpawningPlatform = Input.is_action_just_pressed("spawnPlatform") && get_tree().get_nodes_in_group("playerBullets").size() > 0
	
	
########SHOOTING/SPAWNINGPLATFORM FUNCTIONS#########

	if currentState == playerState.idling:
		if isShooting:
			$shoot.shoot()
			animationState.travel("shootFromIdle")
		elif isSpawningPlatform:
			spawnPlatform()
			animationState.travel("spawnPlatformFromIdle")


	if currentState == playerState.running:
		if isShooting:
			$shoot.shoot()
			animationState.travel("shootFromRun")
		elif isSpawningPlatform:
			spawnPlatform()
			animationState.travel("spawnPlatformFromRun")

	if currentState == playerState.jumping:
		if isShooting:
			$shoot.shoot()
			animationState.travel("shootFromAir")
		elif isSpawningPlatform:
			spawnPlatform()
			animationState.travel("spawnPlatformFromAir")

	if currentState == playerState.doubleJumping:
		if isShooting:
			$shoot.shoot()
			animationState.travel("shootFromAir")
		elif isSpawningPlatform:
			spawnPlatform()
			animationState.travel("spawnPlatformFromAir")


	if currentState == playerState.falling:
		if isShooting:
			$shoot.shoot()
			animationState.travel("shootFromAir")
		elif isSpawningPlatform:
			spawnPlatform()
			animationState.travel("spawnPlatformFromAir")
	
	if currentState == playerState.sliding:
		if isShooting:
			$shoot.shoot()
			animationState.travel("shootFromIdle") ###########bräüchte ne neue animation
		elif isSpawningPlatform:
			spawnPlatform()
			animationState.travel("spawnPlatformFromIdle") ###########bräüchte ne neue animation

	
############SPRITE FLIPPING##############################
	flipSprite()
	
#############VELOCITY UPDATES############################


	
	
	if(youWon || isDying || isDrowning):
		if(isDrowning):
			sinkIntoJelly()
	
	
	else:
		if(isStandingOnMiniPlatform):
			velocity.x = getHorizontalDirection() * speed + slipDirection * slipperyFactorOnMiniPlatform
		else:
			velocity.x = getHorizontalDirection() * speed
		velocity.y += gravity * delta

		var isInTheAir = not is_on_floor() #Zusammenhängender code sollte hintereinander stehen.
		if isInTheAir:
			velocity.x = getHorizontalDirection() * speed/2 #damit bewegt sich der player langsamer, wenn in der luft. Simuliert "luft reibung"
		
		if(!isDead):
			velocity = move_and_slide(velocity, Vector2.UP, true) #char slides along the floor




################END OF THE PHYSICS PROCESS##########################################
func flipSprite():
	if(!isDead && !youWon):
		if(Input.is_action_pressed("ui_right")):
			$sprite.flip_h = false
		elif(Input.is_action_pressed("ui_left")):
			$sprite.flip_h = true


#spawn smaller platforms, depending on the energy level
func spawnPlatform(): 
	var playerPlatform
	
	match energy:
		5:           
		  playerPlatform = playerPlatform5Scene.instance()
		4: 
		  playerPlatform = playerPlatform4Scene.instance()
		3:
		  playerPlatform = playerPlatform3Scene.instance()
		2:
		  playerPlatform = playerPlatform2Scene.instance()
		1, 0:
		  playerPlatform = playerPlatform1Scene.instance()

	$sfx/spawnPlatformSfx.playing = true
	get_tree().root.add_child(playerPlatform) #we make the platform a child of the world
	
	var bullet = get_tree().get_nodes_in_group("playerBullets")[0] #this is not path-dependent anymore!
	playerPlatform.position = bullet.position
	
	bullet.queue_free()
	
	if get_tree().get_nodes_in_group("playerPlatforms").size() > maxPlayerPlatformsAtSameTime:
		deleteOldestPlatform()

	
	
	isAtFullEnergy = false #after spawning a platform we will never be at full energy
	if (energy != 1):
		energy -= 1 ##schritt 1: wert im player script geändert
		myAutoloadScript.playerEnergy -= 1 ###schritt 2: hier ändern wir den wert der variable in der autoload datei, damit der hud script das sehen kann
	
	
	#relative path (starting from current node and follow the path to the destination. ".." means "up one level"	
	hud.updateUI() ###############MEGA PROBLEM!!!! FUNKTIONIERT NICHT, WENN DER PLAYER IM TREE ANDERS Pd OSITIONIERT WIRD!##########


##########STATE MACHINE FUNCTIONS###################
func getHorizontalDirection():
	return Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") #wir verwenden eine funktion anstatt eine temporäre variable
#falsch wäre in der _physics_process zu definieren "var horizontalDirection = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))"
#und dann velocity.x = horizontalDirection * speed


func enterState(newState):
	currentState = newState #kann man das nicht einfach in der enterState funktion schreiben?
	
	match currentState:
		playerState.idling:           
			idlingState.idle()
#			animationState.travel("idle")
		playerState.running: 
			runningState.run()
#			animationState.travel("run")
		playerState.jumping:
			jumpingState.jump()
			animationState.travel("jump")
		playerState.doubleJumping:
			doubleJumpingState.doubleJump()
			animationState.travel("doubleJump")
		playerState.falling:
			fallingState.fall()
			animationState.travel("falling")
		playerState.sliding:
			slidingState.slide()
			animationState.travel("sliding")
		playerState.drowning:
			drowningState.drown()
			animationState.travel("drowning")
		playerState.dying:
			dyingState.die()
			animationState.travel("dying")
		playerState.winning:           
			winningState.win() 
			animationState.travel("winning")


func changeStateTo(newState):
	enterState(newState)


func updatePlayerState():
	if (currentState == playerState.idling):
#		print("we are idling" + " standing on yellow trap: " + str(isStandingOnYellowTrap))
		if(getHorizontalDirection() != 0): 
			changeStateTo(playerState.running)
		if(Input.is_action_just_pressed("jump") and is_on_floor()):
			changeStateTo(playerState.jumping)
		if(velocity.y > 0.0 and not is_on_floor()):
			changeStateTo(playerState.falling)
		if(isDying):
			changeStateTo(playerState.dying)



	if (currentState == playerState.running):
#		print("we are running" + " standing on yellow trap: " + str(isStandingOnYellowTrap))
		if(getHorizontalDirection() == 0): 
			changeStateTo(playerState.idling)
		if(Input.is_action_just_pressed("jump") and is_on_floor()):
			changeStateTo(playerState.jumping)
		if(velocity.y > 0.0 and not is_on_floor()):
			changeStateTo(playerState.falling)
		if(isDying):
			changeStateTo(playerState.dying)
		if(youWon):
			changeStateTo(playerState.winning)



	if (currentState == playerState.jumping):
#		print("we are jumping" + " standing on yellow trap: " + str(isStandingOnYellowTrap))
		yield(get_tree(), "physics_frame") #we wait one frame. otherwise we would enter the doubleJumping state straight after clicking "jump" the first time, since "Input.is_action_just_pressed" is true only on the frame that it is pressed 
		if(Input.is_action_just_pressed("jump") and jumpsMade == 1):
			changeStateTo(playerState.doubleJumping)
		if(velocity.y > 0.0 and not is_on_floor()):
			changeStateTo(playerState.falling)
		if(isDying):
			changeStateTo(playerState.dying)



	if (currentState == playerState.doubleJumping):
#		print("we are double jumping" + " standing on yellow trap: " + str(isStandingOnYellowTrap))
		if(velocity.y > 0.0 and not is_on_floor()):
			changeStateTo(playerState.falling)
		if(isDying):
			changeStateTo(playerState.dying)


	if (currentState == playerState.falling):
#		print("we are falling" + " standing on yellow trap: " + str(isStandingOnYellowTrap))
		if(is_on_floor() and getHorizontalDirection() == 0):
			changeStateTo(playerState.idling)
		if(is_on_floor() and getHorizontalDirection() != 0):
			changeStateTo(playerState.running)
		if(Input.is_action_just_pressed("jump") and jumpsMade == 0):
			changeStateTo(playerState.jumping) 
			yield(get_tree(), "physics_frame") #we wait one frame. otherwise we would enter the doubleJumping state straight after clicking "jump" the first time, since "Input.is_action_just_pressed" is true only on the frame that it is pressed 		
		if(Input.is_action_just_pressed("jump") and jumpsMade == 1):
			changeStateTo(playerState.doubleJumping)
		if(isStandingOnMiniPlatform):
			changeStateTo(playerState.sliding)
		if(isDrowning):
			changeStateTo(playerState.drowning)
		if(isDying):
			changeStateTo(playerState.dying)
		if(youWon):
			changeStateTo(playerState.winning)
	
	
	
	if (currentState == playerState.sliding):
#		print("we are sliding" + " standing on yellow trap: " + str(isStandingOnYellowTrap))
		if(Input.is_action_just_pressed("jump") and is_on_floor()):
			changeStateTo(playerState.jumping)
		if(velocity.y > 0.0 and not is_on_floor()):
			changeStateTo(playerState.falling)
		if(isDying):
			changeStateTo(playerState.dying)


	if (currentState == playerState.winning):
		pass


###########PICKUP FUNCTIONS#################
func collideWithHealth():
	if(health <= 4):
		health += 1 ########schritt 1: das ändert den wert der health NUR in diesem script. Damit die hud die veränderung auch korrekt anzeigen kann, brauchen wir den wert in der autoload datei zu verändern (zeile unten)
		myAutoloadScript.playerHealth += 1	#####schritt 2: wert wird in der autoload datei geändert
		weCanDeleteHealthPickupWeJustCollidedWith = true
		hud.updateUI() ###############MEGA PROBLEM!!!! FUNKTIONIERT NICHT, WENN DER PLAYER IM TREE ANDERS POSITIONIERT WIRD!##########




func collideWithEnergy():
	if(energy <= 4):
		hud.get_node("playerStats/energy/spriteGlow").visible = true
		hud.get_node("playerStats/energy/spriteGlow/animationPlayer").play("rotateGlow") #play energy animation
		
		hud.get_node("playerStats/energy/energySprite/animationPlayer").play("rotateImage") #play glow animation on the energy sprite bar
		
		energy += 1 ########schritt 1: das ändert den wert der health NUR in diesem script. Damit die hud die veränderung auch korrekt anzeigen kann, brauchen wir den wert in der autoload datei zu verändern (zeile unten)
		myAutoloadScript.playerEnergy += 1	#####schritt 2: wert wird in der autoload datei geändert
		weCanDeleteEnergyPickupWeJustCollidedWith = true
		hud.updateUI() ###############MEGA PROBLEM!!!! FUNKTIONIERT NICHT, WENN DER PLAYER IM TREE ANDERS POSITIONIERT WIRD!##########




func collideWithBonus():
	bonus += 1 ########schritt 1: das ändert den wert der health NUR in diesem script. Damit die hud die veränderung auch korrekt anzeigen kann, brauchen wir den wert in der autoload datei zu verändern (zeile unten)
	myAutoloadScript.playerBonus += 1	#####schritt 2: wert wird in der autoload datei geändert
	hud.updateUI() ###############MEGA PROBLEM!!!! FUNKTIONIERT NICHT, WENN DER PLAYER IM TREE ANDERS POSITIONIERT WIRD!##########



###########DAMAGE FUNCTIONS#################
func hurt():
	animationState.travel("hurt")
	spawnBloodParticleVfx()
	$sfx/hurtSfx.playing = true
	
func exitHurtAnimation():
	match currentState:
		playerState.idling:           
		  idlingState.idle()
		playerState.running:           
		  runningState.run()
		
func exitShootFromRunAnimation():
	match currentState:
		playerState.idling:           
		  idlingState.idle()
		playerState.running:           
		  runningState.run()




func collideWithSpikes():
	health -= 1  ########schritt 1: das ändert den wert der health NUR in diesem script. Damit die hud die veränderung auch korrekt anzeigen kann, brauchen wir den wert in der autoload datei zu verändern (zeile unten)
	myAutoloadScript.playerHealth -= 1 ###schritt 2: hier ändern wir den wert der variable in der autoload datei, damit der hud script das sehen kann
	if(health > 0):
		hurt()

	hud.updateUI() ###############MEGA PROBLEM!!!! FUNKTIONIERT NICHT, WENN DER PLAYER IM TREE ANDERS POSITIONIERT WIRD!##########
	if(health <= 0):
		isDying = true;


func collideWithSinusDisk():
	health -= 1 ########schritt 1: das änder den wert der health NUR in diesem script. Damit die hud die veränderung auch korrekt anzeigen kann, brauchen wir den wert in der autoload datei zu verändern (zeile unten)
	myAutoloadScript.playerHealth -= 1	#####schritt 2: wert wird in der autoload datei geändert
	if(health > 0):
		hurt()

	hud.updateUI() ###############MEGA PROBLEM!!!! FUNKTIONIERT NICHT, WENN DER PLAYER IM TREE ANDERS POSITIONIERT WIRD!##########
	if(health <= 0):
		isDying = true;
		


func collideWithCircleDisk():
	health -= 1 ########schritt 1: das änder den wert der health NUR in diesem script. Damit die hud die veränderung auch korrekt anzeigen kann, brauchen wir den wert in der autoload datei zu verändern (zeile unten)
	myAutoloadScript.playerHealth -= 1	#####schritt 2: wert wird in der autoload datei geändert
	if(health > 0):
		hurt()

	hud.updateUI() ###############MEGA PROBLEM!!!! FUNKTIONIERT NICHT, WENN DER PLAYER IM TREE ANDERS POSITIONIERT WIRD!##########
	if(health <= 0):
		isDying = true;
		

func collideWithCircleDiskUnpredictable():
	health -= 1 ########schritt 1: das änder den wert der health NUR in diesem script. Damit die hud die veränderung auch korrekt anzeigen kann, brauchen wir den wert in der autoload datei zu verändern (zeile unten)
	myAutoloadScript.playerHealth -= 1	#####schritt 2: wert wird in der autoload datei geändert
	if(health > 0):
		hurt()

	hud.updateUI() ###############MEGA PROBLEM!!!! FUNKTIONIERT NICHT, WENN DER PLAYER IM TREE ANDERS POSITIONIERT WIRD!##########
	if(health <= 0):
		isDying = true;
		

func collideWithPendulumBall():
	health -= 1 ########schritt 1: das änder den wert der health NUR in diesem script. Damit die hud die veränderung auch korrekt anzeigen kann, brauchen wir den wert in der autoload datei zu verändern (zeile unten)
	myAutoloadScript.playerHealth -= 1	#####schritt 2: wert wird in der autoload datei geändert
	if(health > 0):
		hurt()

	hud.updateUI() ###############MEGA PROBLEM!!!! FUNKTIONIERT NICHT, WENN DER PLAYER IM TREE ANDERS POSITIONIERT WIRD!##########
	if(health <= 0):
		isDying = true;
		
		

func collideWithJelly():
	isDrowning = true
	health = 0 ########schritt 1: das änder den wert der health NUR in diesem script. Damit die hud die veränderung auch korrekt anzeigen kann, brauchen wir den wert in der autoload datei zu verändern (zeile unten)
	myAutoloadScript.playerHealth = 0 #####schritt 2: wert wird in der autoload datei geändert
	hud.updateUI()

func sinkIntoJelly():
	position.y += 1

#don't try to put this in a "defeatMenu" script attached on the root node of the defeatMenu scene
func displayDefeatMenu():
	isDead = true
	defeatMenu.visible = true
	get_tree().paused = true
	get_node("../../gui/defeatMenu/syrupDetailsWithSprite/animationPlayer").play("syrupDripWithSpriteAnimation")





#############STANDING-ON FUNCTIONS########
func standOnMiniPlatformLxPart():
	isStandingOnMiniPlatform = true
	slipDirection = -1

func standOnMiniPlatformRxPart():
	isStandingOnMiniPlatform = true
	slipDirection = +1

func exitMiniPlatform():
	isStandingOnMiniPlatform = false



##############UTILITY FUNCTIONS##############
func deletePlayer():
	isDead = true #damit die camera auf den player zentiert bleibt, wenn er stirbt


func playerReset():
	health = 5  ########schritt 1: das ändert den wert der health NUR in diesem script. Damit die hud die veränderung auch korrekt anzeigen kann, brauchen wir den wert in der autoload datei zu verändern (zeile unten)
	myAutoloadScript.playerHealth = 5 ###schritt 2: hier ändern wir den wert der variable in der autoload datei, damit der hud script das sehen kann

	energy = 5  ########schritt 1: das ändert den wert der health NUR in diesem script. Damit die hud die veränderung auch korrekt anzeigen kann, brauchen wir den wert in der autoload datei zu verändern (zeile unten)
	myAutoloadScript.playerEnergy = 5 ###schritt 2: hier ändern wir den wert der variable in der autoload datei, damit der hud script das sehen kann

	bonus = 0  ########schritt 1: das ändert den wert der health NUR in diesem script. Damit die hud die veränderung auch korrekt anzeigen kann, brauchen wir den wert in der autoload datei zu verändern (zeile unten)
	myAutoloadScript.playerBonus = 0 ###schritt 2: hier ändern wir den wert der variable in der autoload datei, damit der hud script das sehen kann


func deleteOldestPlatform():
	spawnPlayerPlatformDeathTogetherParticleVfx(get_tree().get_nodes_in_group("playerPlatforms")[0].position)
	get_tree().get_nodes_in_group("playerPlatforms")[0].queue_free()


func spawnPlayerPlatformDeathTogetherParticleVfx(positionToBeSpawnedAt):
	var playerPlatformDeathTogetherParticleVfx = playerPlatformDeathTogetherParticleVfxScene.instance()
	get_tree().root.add_child(playerPlatformDeathTogetherParticleVfx) #we make the particle vfx a child of the world, so it doesn't get queue freed together with the platform
	playerPlatformDeathTogetherParticleVfx.global_position = positionToBeSpawnedAt

func spawnBloodParticleVfx():
	var bloodParticleVfx = bloodParticleVfxScene.instance()
	add_child(bloodParticleVfx) 
	bloodParticleVfx.global_position = position

func _on_pauseButton_mouse_entered():
	isHoveringPauseBtn = true
	

func _on_pauseButton_mouse_exited():
	isHoveringPauseBtn = false
