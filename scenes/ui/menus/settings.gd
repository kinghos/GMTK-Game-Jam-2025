extends Control

@onready var menu_back_arrow = $MenuBackArrow

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	if get_tree().is_paused():
		$Background.queue_free()
		var container = get_node("Container")
		container.get_node("MenuBackArrow").size.x = 250
		container.get_node("VolumeSlidersContainer").position = Vector2(710, 379)
		container.get_node("ColorRect").position = Vector2(685, 365)
