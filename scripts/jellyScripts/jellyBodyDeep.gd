extends Node2D


export var k = 0.015 #spring stiffness constant
export var d = 0.03 #dampening value
export var spread = 0.0002

var springs = []
var passes = 8 #we want the whole body of water to move in the same frame we created the wave. The "passes" variable tells us how much this process is repeated every frame. This makes our wave spread much faster


export var distanceBetweenSprings = 32 #dist in pixel btw each spring
export var springNumber = 6 #nr of springs in the scene
var jellyLenght = distanceBetweenSprings * springNumber
onready var jellySpring = preload("res://scenes/trapScenes/jellyScenes/jellySpring.tscn")

export var depth = 500#the depth of the jelly body #IT DOES NOT WORK TO CHANGE THIS IN THE INSPECTOR. CHANGE IT FROM THE CODE
var targetHeight = global_position.y
var bottom = targetHeight + depth #holds the bottom position of our jelly body
onready var jellyPolygon = $jellyPolygon
onready var jellyBorder = $jellyBorder
export var borderThickness = 1.1

onready var collisionShape = $jellyBodyArea/collisionShape2D
onready var jellyBodyArea = $jellyBodyArea



func _ready():
	setup()

	

func setup():
	jellyBorder.width = borderThickness
#		spread = spread / 1000
	for i in springNumber:
		var xPosition = distanceBetweenSprings * i
		var j = jellySpring.instance()
		add_child(j)
		springs.append(j)
		j.initialize(xPosition, i) #initialize is a function we defined in the jellySpring script
		j.setCollisionWidth(distanceBetweenSprings)
		j.connect("splash", self, "splash")
		
	var totalLenght = distanceBetweenSprings * (springNumber - 1)
	var rectangle = RectangleShape2D.new().duplicate()
	var rectPosition = Vector2(totalLenght/2, depth/2) #the rectangle shape gets placed in the center of the jelly body
	var recExtents = Vector2(totalLenght/2, depth/2) #the extents of the rectangle are half of the size of the jelly body
	
	jellyBodyArea.position = rectPosition
	rectangle.set_extents(recExtents)
	collisionShape.set_shape(rectangle)
	#this gives us an area2D that covers all our jelly Body


func _physics_process(delta):
	updateCollisions()


func updateCollisions():
	for i in springs:
		i.jellyUpdate(k, d)

	var leftDeltas = []
	var rightDeltas = []

	#initialize the values with an array of zeros
	for i in springs.size():
		leftDeltas.append(0)
		rightDeltas.append(0)
		
		
	for j in range(passes):
		for i in springs.size(): #if there exists a "left neighbour"
			if i > 0:
				leftDeltas[i] = spread * (springs[i].height - springs[i-1].height)
				springs[i-1].velocity += leftDeltas[i] #increments the velocity of the left neighbour, using the height difference between the node and its left neighbour
			if i < springs.size() - 1: # it there exists a "right neighbour"
				rightDeltas[i] = spread * (springs[i].height - springs[i+1].height)
				springs[i+1].velocity += rightDeltas[i]
	newBorder() #makes a nice smooth border on the jelly surface
	drawJellyBody()



func drawJellyBody():
	#this is how we started: our surface was just a collection of points connected by a line
#	var surfacePoints = [] #will hold the positions of our springs
#	for i in springs.size():
#		surfacePoints.append(springs[i].position)

	#this is the "better" variant, using a smooth curve for the body
	var curve = jellyBorder.curve
	var points = Array(curve.get_baked_points()) #this gets the point of the curve and makes an array of them
	#point.size() ist die springNumber TIP!!!
	
	var jellyPolygonsPoints = points #the jelly polygons will contain all the points of the polygon
	
	
	var firstIndex = 0
	var lastIndex = jellyPolygonsPoints.size() - 1
	
	
	#add other two points at the bottom of the polygon, to enclose the jelly body
	jellyPolygonsPoints.append(Vector2(jellyPolygonsPoints[lastIndex].x, bottom))
	jellyPolygonsPoints.append(Vector2(jellyPolygonsPoints[firstIndex].x, bottom))
	
	#transforms our normal array into a poolvector2 array 
	#the polygon draw function uses poolvector2arrays to draw the polygon. Thats why we converted it
	jellyPolygonsPoints = PoolVector2Array(jellyPolygonsPoints) 
	
	#fügt uv koord hinzu
	var maxX = $jellyPolygon.texture.get_width()
	var maxY = $jellyPolygon.texture.get_height()
	var numSprings = curve.get_baked_points().size()
	var jellyPolygonUvs = PoolVector2Array()
	for i in numSprings:
		var uv = Vector2(i * maxX/(numSprings-1), 0) #gesamte breite/numSpings-1
		jellyPolygonUvs.append(uv)
	jellyPolygonUvs.append(Vector2(jellyPolygonUvs[lastIndex].x, maxY))
	jellyPolygonUvs.append(Vector2(jellyPolygonUvs[firstIndex].x, maxY))
	
	
	jellyPolygon.set_polygon(jellyPolygonsPoints)
	jellyPolygon.set_uv(jellyPolygonUvs)
	



func newBorder():
	#Draws a new border of the jelly. This will be called each frame
	var curve = Curve2D.new().duplicate()
	
	var surfacePoints = []
	for i in springs.size():
		surfacePoints.append(springs[i].position)
	
	for i in surfacePoints.size():
		curve.add_point(surfacePoints[i])
	
	jellyBorder.curve = curve
	jellyBorder.smooth(true)
	jellyBorder.update()



func splash(index, speed): #index is the spring we want to move and speed is the speed that gets added to the spring
	if index >= 0 and index < springs.size(): #makes sure the index is inside the boundaries of the springs array so that we make sure that we can pick the spring at "index"
		springs[index].velocity += speed #add speed to the spring


func _on_jellyBodyArea_body_entered(body):
	if body.has_method("collideWithJelly"):
		body.collideWithJelly()
#		print("jelly entered")

#func setDepth(value):
#	depth = value
#	setup()
