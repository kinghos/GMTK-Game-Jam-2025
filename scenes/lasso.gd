extends Node2D
class_name Lasso

@onready var line = $LassoLine
@onready var line_from_player = $PlayerToLassoLine
@onready var lasso_polygon = $LassoPolygon

@export var player: Player

@export var MAX_LASSO_LENGTH = 600
@export var DISTANCE_THRESHOLD = 7
@export var LASSO_COMPLETION_GAP = 100

var points: PackedVector2Array = []
var is_drawing = false
var fade_out_tweens: Array[Tween]

func _ready():
	Globals.lasso = self

func _process(_delta):
	if is_drawing:
		# Handle the drawing of the main lasso
		var pos = get_global_mouse_position()
		if points.is_empty() or pos.distance_to(points[-1]) > DISTANCE_THRESHOLD:
			var new_lasso_length = calculate_perimeter_with_extra_point(points, pos)
			if new_lasso_length <= MAX_LASSO_LENGTH:
				var new_segment_start = points[-1] if points.size() > 0 else pos
				var crossed = false
				for i in range(points.size() - 2):
					if Geometry2D.segment_intersects_segment(points[i], points[i + 1], new_segment_start, pos):
						crossed = true
						break
				if crossed:
					finish_lasso()
				else:
					points.append(pos)
					line.add_point(pos)
			else:
				finish_lasso()
	
	# Cancel lasso if the player moves further away than their reach
	if !points.is_empty() and Globals.player.global_position.distance_to(points[0]) > Globals.player_lasso_reach:
		finish_lasso(true)
	
	var player_lasso_start = player.get_node("LassoStart").global_position
	
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - player_lasso_start).normalized()
	var distance = Globals.player.global_position.distance_to(mouse_pos)
	
	if distance <= Globals.player_lasso_reach:
		line_from_player.points = [player_lasso_start, mouse_pos]
		line_from_player.modulate = Color.WHITE
	else:
		var clamped_point = player_lasso_start + direction * Globals.player_lasso_reach
		line_from_player.points = [player_lasso_start, clamped_point]
		line_from_player.modulate = Color.RED

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and Globals.player.global_position.distance_to(get_global_mouse_position()) <= Globals.player_lasso_reach:
			# prevent lasso drawing if mouse hovering over pen
			for pen: Pen in get_tree().get_nodes_in_group("Pens"):
				if pen.is_mouse_over:
					print("e")
					return
			start_lasso()
		else:
			if is_drawing:
				finish_lasso()

func start_lasso():
	$LassoLine.modulate = Color(1, 1, 1, 1)
	is_drawing = true
	for tween in fade_out_tweens:
		tween.stop()
	clear()

func finish_lasso(cancel: bool = false):
	is_drawing = false
	if points.size() >= 3 and not cancel:
		close_shape()
		update_polygon()
		stun_animals_in_lasso()
		fade_out()
	else:
		clear()

func close_shape():
	if points.size() > 1 and points[0] != points[-1]:
		points.append(points[0])
		line.add_point(points[0])

func update_polygon():
	lasso_polygon.polygon = points

func clear():
	points.clear()
	line.clear_points()
	lasso_polygon.polygon = []

func fade_out():
	var tween = get_tree().create_tween()
	fade_out_tweens.append(tween)
	tween.tween_property(line, "modulate", Color(1, 1, 1, 0), 1)
	await tween.finished
	clear()
	fade_out_tweens.erase(tween)
	modulate = Color(1, 1, 1, 1)

func calculate_perimeter_with_extra_point(existing_points: PackedVector2Array, new_point: Vector2) -> float:
	var total = 0
	for i in range(existing_points.size() - 1):
		total += existing_points[i].distance_to(existing_points[i + 1])
	if existing_points.size() > 0:
		total += existing_points[-1].distance_to(new_point)
	return total

func stun_animals_in_lasso():
	var animals = get_tree().get_nodes_in_group("Animals")
	
	var i = 1
	for animal in animals:
		if animal is BaseAnimal:
			var local_pos = to_local(animal.global_position)
			if Geometry2D.is_point_in_polygon(local_pos, lasso_polygon.polygon):
				if !animal.being_stunned and !animal.being_kicked:
					animal.stun(i)
					i += 1

# Unused for now: do we want to make sure the lasso drawn by the player is circular?
func is_shape_circular(points: PackedVector2Array) -> bool:
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
