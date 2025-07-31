extends Sprite2D

const SCREEN_MARGIN: float = 10.0

func _ready():
	hide()

func _process(delta: float) -> void:
	var camera_node = get_viewport().get_camera_2d()
	var screen_dimensions: Vector2 = get_viewport().get_visible_rect().size
	var screen_center = screen_dimensions / 2
	
	var target_global_position: Vector2 = get_parent().global_position
	var screen_coordinates: Vector2 = (target_global_position -  camera_node.global_position) + screen_center
	
	var screen_inset_rectangle: Rect2 = Rect2(Vector2.ZERO, screen_dimensions).grow(-SCREEN_MARGIN)
	
	if !screen_inset_rectangle.has_point(screen_coordinates):
		var clamped_x = clamp(screen_coordinates.x, SCREEN_MARGIN, screen_dimensions.x - SCREEN_MARGIN)
		var clamped_y = clamp(screen_coordinates.y, SCREEN_MARGIN, screen_dimensions.y - SCREEN_MARGIN)
		var clamped_screen_coords: Vector2 = Vector2(clamped_x, clamped_y)
		
		global_position = camera_node.global_position + (clamped_screen_coords - screen_center)
		
		show()
	else:
		hide()
