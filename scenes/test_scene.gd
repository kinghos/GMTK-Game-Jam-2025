extends Node2D

@onready var line = $Line2D
@onready var polygon = $Polygon2D

var points: Array[Vector2] = []
var is_drawing := false

const MAX_LASSO_LENGTH = 1000
const THE_DISTANCE_YOU_NEED_THE_LINE_TO_BE_BELOW_TO_MAKE_THE_SHAPE = 100.0

func _process(delta):
	if is_drawing:
		var pos = get_global_mouse_position()
		if points.is_empty() or pos.distance_to(points[-1]) > 5.0:
			var new_perimeter = calculate_perimeter_with_extra_point(points, pos)
			if new_perimeter <= MAX_LASSO_LENGTH:
				points.append(pos)
				line.add_point(pos)
			else:
				make_shape()
				print("Reached max length!")

func calculate_perimeter_with_extra_point(points: Array[Vector2], new_point: Vector2) -> float:
	var total = 0
	if points.is_empty():
		return 0
	
	for i in range(points.size() - 1):
		total += points[i].distance_to(points[i + 1])
	
	total += points[-1].distance_to(new_point)
	
	return total

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_drawing = true
			clear()
		else:
			is_drawing = false
			make_shape()

func make_shape():
	line.add_point(points[0])
	points.append(points[0])

	polygon.polygon = points
	polygon.color = Color.RED
	#if is_shape_circular(points):
		#polygon.polygon = points
		#polygon.color = Color.RED
	#else:
		#print("shape isn't circular")
		#clear()

func clear():
	points.clear()
	line.clear_points()
	polygon.polygon = []

func is_shape_circular(points: Array[Vector2]) -> bool:
	if points.size() < 3:
		return false
	
	var area = 0
	var perimeter = 0
	
	for i in points.size():
		var p1 = points[i]
		var p2 = points[(i + 1) % points.size()]
		area += (p1.x * p2.y - p2.x * p1.y) / 2
		perimeter += p1.distance_to(p2)
	
	area = abs(area)
	
	if perimeter == 0:
		return false
	
	return (4 * PI * area) / (perimeter * perimeter) >= 0.9
