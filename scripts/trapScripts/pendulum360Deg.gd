extends StaticBody2D


var isGoingRx = true

export var crazyness = 200 #"unpredictability factor"
#export var applyImpulseTimer = 2 setget setApplyImpulseTimer

onready var pendulumBall = $pendulumBall



func _on_applyImpulseTimer_timeout():
	if(isGoingRx):
		pendulumBall.linear_velocity.x = 0
		pendulumBall.linear_velocity.y = 0	
		pendulumBall.angular_velocity = 0
		pendulumBall.apply_central_impulse(Vector2(-crazyness, crazyness))
		isGoingRx = false
	else:
		pendulumBall.linear_velocity.x = 0
		pendulumBall.linear_velocity.y = 0	
		pendulumBall.angular_velocity = 0
		pendulumBall.apply_central_impulse(Vector2(crazyness, crazyness))
		isGoingRx = true
	$trapSfx.playing = true

#func setApplyImpulseTimer(value):
#	applyImpulseTimer = value
#	$pendulumBall/applyImpulseTimer.wait_time = applyImpulseTimer	


func _on_damageArea2D_body_entered(body):
	if body.has_method("collideWithPendulumBall"):
		body.collideWithPendulumBall()
