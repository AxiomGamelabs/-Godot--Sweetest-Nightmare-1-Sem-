extends ParallaxLayer


export(float) var cloudSpeed = -15

func _process(delta):
	self.motion_offset.x += cloudSpeed * delta
