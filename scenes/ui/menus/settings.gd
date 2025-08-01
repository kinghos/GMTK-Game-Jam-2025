extends Control

@onready var menu_back_arrow = $MenuBackArrow

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	if get_tree().is_paused():
		$TextureRect.hide()
		menu_back_arrow.hide()
