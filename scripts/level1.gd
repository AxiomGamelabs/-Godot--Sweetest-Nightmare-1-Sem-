extends Node2D


#func _input(event):
#	if event.is_action_pressed("energyCheat"):
#		energyCheat()
#	if event.is_action_pressed("healthCheat"):
#		healthCheat()
#		print(get_tree().get_nodes_in_group("bonusPickups").size())


func _ready():
	get_tree().paused = false



func energyCheat():
	get_node("playableLayer/player").energy = 5 #schritt 1: wert wird im player script geändert, damit die player logik (zb. sterben funktioniert
	myAutoloadScript.playerEnergy = 5 #Schritt 2: wert wird in der autoload datei geändert, damit die hud es korrekt anzeigen kann
	$gui/hud.updateUI()
	
func healthCheat():
	get_node("playableLayer/player").health = 5 #schritt 1: wert wird im player script geändert, damit die player logik (zb. sterben funktioniert
	myAutoloadScript.playerHealth = 5 #Schritt 2: wert wird in der autoload datei geändert, damit die hud es korrekt anzeigen kann
	$gui/hud.updateUI()
