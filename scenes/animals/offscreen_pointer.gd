extends Sprite2D

const SCREEN_MARGIN: float = 100.0

func _ready():
	hide()

func _process(delta: float) -> void:
	var target_global_position: Vector2 = get_parent().global_position
	
	var camera: Camera2D = get_viewport().get_camera_2d()
	var camera_center: Vector2 = camera.get_screen_center_position()
	
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	var half_screen = screen_size / 2
	
	var visible_rect = Rect2(
		camera_center - half_screen,
		screen_size
	)
	
	if not visible_rect.has_point(target_global_position):
		show()
		global_position.x = clamp(target_global_position.x, visible_rect.position.x + SCREEN_MARGIN, visible_rect.position.x + visible_rect.size.x - SCREEN_MARGIN)
		global_position.y = clamp(target_global_position.y, visible_rect.position.y + SCREEN_MARGIN, visible_rect.position.y + visible_rect.size.y - SCREEN_MARGIN)
		rotation = (target_global_position - global_position).angle()
	else:
		hide()
