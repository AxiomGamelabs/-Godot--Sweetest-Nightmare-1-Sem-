extends Line2D



var d = 0.0 #just a counter
export var lenght = 50
var point = Vector2()
export var yConnectionPointTrailToTrap = 20 

func _process(delta):

	global_position = Vector2(0, yConnectionPointTrailToTrap)

	global_rotation = 0

	point = get_parent().global_position

	add_point(point)
	while get_point_count()>lenght:
		remove_point(0)
