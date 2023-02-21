class_name SmoothPath
extends Path2D

export var splineLength = 8
export(bool) var _smooth setget smooth
export(bool) var _straighten setget straighten
export(Color) var color = Color(1,1,1,1)
var width = 8

func straighten(value):
	if not value: return
	for i in range(curve.get_point_count()):
		curve.set_point_in(i, Vector2())
		curve.set_point_out(i, Vector2())

func smooth(value):
	if not value: return

	var pointCount = curve.get_point_count()
	for i in pointCount:
		if i >0 and i < pointCount-1:
			var spline = getSpline(i)
			curve.set_point_in(i, -spline)
			curve.set_point_out(i, spline)

func getSpline(i):
	
	var lastPoint = getPoint(i - 1)
	var nextPoint = getPoint(i + 1)
	var spline = lastPoint.direction_to(nextPoint) * splineLength
	return spline

func getPoint(i):
	var pointCount = curve.get_point_count()
	i = wrapi(i, 0, pointCount )
	if i >1 and i < pointCount-1:
		return curve.get_point_position(i)
	elif i <= 1:
		return Vector2(curve.get_point_position(1).x - splineLength,curve.get_point_position(1).y)
	elif i >= pointCount-1:
		return Vector2(curve.get_point_position(pointCount-1).x + splineLength,curve.get_point_position(pointCount-1).y)

func _draw():
	var points = curve.get_baked_points()
	if points:
		draw_polyline(points, color, width, true)
