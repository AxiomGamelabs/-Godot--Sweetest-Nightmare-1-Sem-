extends StaticBody2D


onready var ball = $ball
export var crazyness = 300

var initialImpulseIsApplied = false


func _process(delta):
	if (!initialImpulseIsApplied):
		ball.apply_central_impulse(Vector2(-crazyness, crazyness))
		initialImpulseIsApplied = true


func _on_applyImpulseTimer_timeout():
	ball.linear_velocity.x = 0
	ball.linear_velocity.y = 0
	ball.angular_velocity = 0
	ball.apply_central_impulse(Vector2(-crazyness, crazyness))
	$trapSfx.playing = true



func _on_damageArea2D_body_entered(body):
	if body.has_method("collideWithCircleDiskUnpredictable"):
		body.collideWithCircleDiskUnpredictable()
