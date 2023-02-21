extends Line2D



var d = 0.0 #just a counter
export var lenght = 50
var point = Vector2()
export var connectionPointTrailToTrap = 27


func _process(delta):
	
	d += delta
	
#	global_position = Vector2(xConnectionPointTrailToTrap, yConnectionPointTrailToTrap)
#	position = get_parent().startPosition + Vector2(get_parent().rotationDirectionFactor * cos(d * get_parent().speed) * get_parent().radius, sin(d * get_parent().speed) * get_parent().radius)
#	position = get_parent().position

	global_rotation = 0
	
	point = get_parent().global_position
	
	add_point(point)
	while get_point_count()>lenght:
		remove_point(0)
