tool
extends KinematicBody2D

var d = 0.0 #just a counter
var startPosition = Vector2()

export (float) var speed = 2 setget setSpeed
export (float) var radius = 200 setget setRadius
export (bool) var clockwise = true
var rotationDirectionFactor

#export (bool) var showMovementInTheEditor = false #BUGGED!

##BUG: when restarting the level, the circle gets drawn with a huge offset in a wrong place


func _ready():
	startPosition = position



func _physics_process(delta):
	if Engine.editor_hint: #if we are currently in the editor
		return

	if(clockwise == true):
		rotationDirectionFactor = +1
	else:
		rotationDirectionFactor = -1


	d += delta

	position = startPosition + Vector2(rotationDirectionFactor * cos(d * speed) * radius, sin(d * speed) * radius)


func setRadius(value):
	radius = value
	update()
#
func setSpeed(value):
	speed = value
	update()
	
func _draw():
	if not Engine.editor_hint:
		return

	var center = startPosition
	var angleFrom = 0
	var angleTo = 360
	drawCircleArc(Vector2(0,0), radius, angleFrom, angleTo, Color('#000000'), 5.0)
	#draw_circle()



func drawCircleArc(center, radius, angleFrom, angleTo, color, width):
	var nbPoints = 32
	var pointsArc = PoolVector2Array()

	for i in range(nbPoints + 1):
		var anglePoint = deg2rad(angleFrom + i * (angleTo - angleFrom) / nbPoints - 90)
		pointsArc.push_back(center + Vector2(cos(anglePoint), sin(anglePoint)) * radius)

	for indexPoint in range(nbPoints):
		draw_line(pointsArc[indexPoint], pointsArc[indexPoint + 1], color, width)


func collideWithPlayerPlatform():
	pass



func _on_damageArea2D_body_entered(body):
	if body.has_method("collideWithCircleDisk"):
		body.collideWithCircleDisk()


