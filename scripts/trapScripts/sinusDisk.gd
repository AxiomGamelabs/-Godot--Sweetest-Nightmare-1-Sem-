tool
extends KinematicBody2D

var time = 0.0
var startPosition = Vector2()
var isGoingRx = true

export (float) var speed = 400 setget setSpeed #the function after "setget" is executed after I change the variable value in the inspector
export (float) var rxLimit = 500 setget setRxLimit
export (float) var amplitude = 80 setget setAmplitude #using setget updates the line in the editor in real time when u change the value
export (float) var factor = 10 setget setFactor

#BUG: irgendwo is noch ein bug drin, dass wenn eine trap sich in der szene befindet, und das level geschlossen und wieder eröffnet wird, die kurve im editor nochmal gezeichnet wird und viel länger aussieht, als die eigentliche trajektorie ist.
#provisorische lösung: Sinus trap deleten und eine neue rein machen
#die richtige lösung wird wahrsch. so aussehen: wenn das level neu geöffnet wird im editor, lösche die alte gezeichnente kurve und zeichne die neue
#momentan wird die alte warsch. nicht gelöscht

func _ready():
	startPosition = position
	
#func _process(delta): #it would cost a looot of performance to update every frame. With 2 traps it lags already
#	if Engine.editor_hint:
#		update()
	


func _physics_process(delta):
	if Engine.editor_hint: #if we are currently in the editor
		return
	
	time += delta
	
	var rxLimitIsReached = position.x > startPosition.x + rxLimit
	var lxLimitIsReached = position.x < startPosition.x
	
	#abhänging von zeitpunkt

	if(isGoingRx):
		position.x += speed * delta #time*factor statt delta und = statt +=
		position.y = (startPosition.y + sin(time * factor) * amplitude)
		if(rxLimitIsReached):
			isGoingRx = false
		
	if(!isGoingRx):
		position.x -= speed * delta
		position.y = startPosition.y + sin(time * factor) * amplitude
		if(lxLimitIsReached):
			isGoingRx = true

	
func setAmplitude(value):
	amplitude = value
	update()
	
func setRxLimit(value):
	rxLimit = value
	update()
	
func setSpeed(value):
	speed = value
	update()

func setFactor(value):
	factor = value
	update()
	
func _draw():
	if not Engine.editor_hint:
		return
		
	#if we are in the editor we draw a curve
	var timeStep = 0.02
	var pointsArray = PoolVector2Array() #we create an array of points, that consists of points on the trajectory of the trap
	for i in range(1000):
		var time = i * timeStep
		var point = Vector2(speed * time, sin(time * factor) * amplitude)
		if(point.x < rxLimit): #wichtig NO startPosition + rxLimit
			pointsArray.append(point)
	draw_polyline(pointsArray, Color('#000000'), 5.0)  #we then use this array to draw the curve


func collideWithPlayerPlatform():
	pass



func _on_damageArea2D_body_entered(body):
	if body.has_method("collideWithSinusDisk"):
		body.collideWithSinusDisk()
