extends StaticBody2D




func _on_damageArea2D_body_entered(body):
	if body.has_method("collideWithPendulumBall"):
		body.collideWithPendulumBall()
