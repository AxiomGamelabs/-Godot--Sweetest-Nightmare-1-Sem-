extends Control


####health und energy NICHT hier oben hinschreiben. Innerhalb der funktionen lassen, damit jedesmal neu geguckt wird, was in der autoload datei steht

const highHealthImg = preload("res://assets/ui/hud/highHealth.png")
const midHealthImg = preload("res://assets/ui/hud/midHealth.png")
const lowHealthImg = preload("res://assets/ui/hud/lowHealth.png")

const heartFullImg = preload("res://assets/ui/hud/hearthFull.png")
const heartEmptyImg = preload("res://assets/ui/hud/hearthEmpty.png")


const energyBar5Img = preload("res://assets/ui/hud/energyBar5.png")
const energyBar4Img = preload("res://assets/ui/hud/energyBar4.png")
const energyBar3Img = preload("res://assets/ui/hud/energyBar3.png")
const energyBar2Img = preload("res://assets/ui/hud/energyBar2.png")
const energyBar1Img = preload("res://assets/ui/hud/energyBar1.png")

onready var glowSprite = $playerStats/glowSprite

#var initialNrOfBonusPickups


func _ready():
	var health = myAutoloadScript.playerHealth
	var energy = myAutoloadScript.playerEnergy
	var bonus = myAutoloadScript.playerBonus
#	initialNrOfBonusPickups = get_tree().get_nodes_in_group("bonusPickups").size()

	#sender node of the "displayFullEnergyMsgSignal"
#	connect("displayFullEnergyMsgSignal", self, "displayFullEnergyMsg")



func updateUI():
	####jedesmal, wenn wir die UI updaten wollen, ließt der hud ab, was für einen wert in der autoload datei steht
	var health = myAutoloadScript.playerHealth
	var energy = myAutoloadScript.playerEnergy
	var bonus = myAutoloadScript.playerBonus
	
	
	#update status texture
	if health == 4 or health == 5:
		$playerStats/status.texture = highHealthImg
	if health == 2 or health == 3:
		$playerStats/status.texture = midHealthImg
	if health == 1:
		$playerStats/status.texture = lowHealthImg

	#update heart images
	match health:
		5:           
			$playerStats/health/healthSprite5.texture = heartFullImg
			$playerStats/health/healthSprite4.texture = heartFullImg
			$playerStats/health/healthSprite3.texture = heartFullImg
			$playerStats/health/healthSprite2.texture = heartFullImg
			$playerStats/health/healthSprite1.texture = heartFullImg
			glowSprite.visible = false
			glowSprite.get_node("animationPlayer").stop()
		4: 
			$playerStats/health/healthSprite5.texture = heartEmptyImg
			$playerStats/health/healthSprite4.texture = heartFullImg
			$playerStats/health/healthSprite3.texture = heartFullImg
			$playerStats/health/healthSprite2.texture = heartFullImg
			$playerStats/health/healthSprite1.texture = heartFullImg
			glowSprite.visible = false
			glowSprite.get_node("animationPlayer").stop()
		3:
			$playerStats/health/healthSprite5.texture = heartEmptyImg
			$playerStats/health/healthSprite4.texture = heartEmptyImg
			$playerStats/health/healthSprite3.texture = heartFullImg
			$playerStats/health/healthSprite2.texture = heartFullImg
			$playerStats/health/healthSprite1.texture = heartFullImg
			glowSprite.visible = false
			glowSprite.get_node("animationPlayer").stop()
		2:
			$playerStats/health/healthSprite5.texture = heartEmptyImg
			$playerStats/health/healthSprite4.texture = heartEmptyImg
			$playerStats/health/healthSprite3.texture = heartEmptyImg
			$playerStats/health/healthSprite2.texture = heartFullImg
			$playerStats/health/healthSprite1.texture = heartFullImg
			glowSprite.visible = false
			glowSprite.get_node("animationPlayer").stop()
		1:
			$playerStats/health/healthSprite5.texture = heartEmptyImg
			$playerStats/health/healthSprite4.texture = heartEmptyImg
			$playerStats/health/healthSprite3.texture = heartEmptyImg
			$playerStats/health/healthSprite2.texture = heartEmptyImg
			$playerStats/health/healthSprite1.texture = heartFullImg
			glowSprite.visible = true
			glowSprite.get_node("animationPlayer").play("statusImagePulsatingGlow")
		0:
			$playerStats/health/healthSprite5.texture = heartEmptyImg
			$playerStats/health/healthSprite4.texture = heartEmptyImg
			$playerStats/health/healthSprite3.texture = heartEmptyImg
			$playerStats/health/healthSprite2.texture = heartEmptyImg
			$playerStats/health/healthSprite1.texture = heartEmptyImg
	

	match energy:
		5:           
			$playerStats/energy/energyBarSprite.texture = energyBar5Img
		4: 
			$playerStats/energy/energyBarSprite.texture = energyBar4Img
		3:
			$playerStats/energy/energyBarSprite.texture = energyBar3Img
		2:
			$playerStats/energy/energyBarSprite.texture = energyBar2Img
		1:
			$playerStats/energy/energyBarSprite.texture = energyBar1Img

	#update bonus text
#	$playerStats/bonus/bonusText.text = str(bonus) + "/" + str(initialNrOfBonusPickups)
	$playerStats/bonus/bonusText.text = str(bonus) + "/" + str(17)




#func displayFullHealthMsg():
#	pass


func _on_setHealthMsgInvisibleAgainTimer_timeout():
	$messages/youAreFullHealthMsg.visible = false



#func displayFullEnergyMsg():
#	$messages/youAreFullEnergyMsg.visible = true
#	$setEnergyMsgInvisibleAgainTimer.start() #activate the invisibility timer as well



func _on_setEnergyMsgInvisibleAgainTimer_timeout():
	$messages/youAreFullEnergyMsg.visible = false



