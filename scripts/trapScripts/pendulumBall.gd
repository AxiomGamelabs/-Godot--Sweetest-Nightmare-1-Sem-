extends RigidBody2D


var isGoingRx = true

export var crazyness = 200

#func ready():
#	apply_central_impulse(Vector2(crazyness, 0))
	

func _on_applyImpulseTimer_timeout():
	if(isGoingRx):
		linear_velocity.x = 0
		linear_velocity.y = 0	
		angular_velocity = 0
		apply_central_impulse(Vector2(-crazyness, crazyness))
		isGoingRx = false
	else:
		linear_velocity.x = 0
		linear_velocity.y = 0	
		angular_velocity = 0
		apply_central_impulse(Vector2(crazyness, crazyness))
		isGoingRx = true



func _on_Area2D_body_entered(body):
	if body.has_method("collideWithPendulumBall"):
		body.collideWithPendulumBall()
