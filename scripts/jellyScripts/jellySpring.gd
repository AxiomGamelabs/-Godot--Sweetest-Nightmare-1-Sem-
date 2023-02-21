extends Node2D

var velocity = 0 #current spring velocity
var force = 0
var height = 0 #current spring height
var targetHeight = 0 #ruhestand
onready var collision = $Area2D/CollisionShape2D
var index = 0 #the index of the spring. We will set it on initialize
var motionFactor = 0.02 #how much an external objects affects the spring (and so the jelly) on collision
var collidedWith = null #we don't want the player to collide with the spring more than once. This var will hold the last object the spring has collided with
signal splash #custom signal


#applies the hooks equation to our spring in each frame
func jellyUpdate(springConstant, dampening):
	height = position.y
	var x = height - targetHeight
	var loss = -dampening * velocity
	force = - springConstant * x + loss
	velocity += force
	position.y += velocity



func initialize(xPosition, id):
	height = position.y
	targetHeight = position.y
	velocity = 0
	position.x = xPosition
	index = id

func setCollisionWidth(value):
	#this func will set the collision shape size of our springs
	var extents = collision.shape.get_extents()
	var newExtents = Vector2(value/2, extents.y)
	collision.shape.set_extents(newExtents)


func _on_Area2D_body_entered(body):
	#this func detects when something hits a spring
	if body == collidedWith: #if the body already collided with the spring, then do not collide
		return
	collidedWith = body
		
	var speed = body.velocity.y * motionFactor #if we don't do this, the speed could be huge. We look at the vertical velocity of the player
	emit_signal("splash", index, speed)
