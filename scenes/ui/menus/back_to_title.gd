extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_pressed() -> void:
	if get_tree().is_paused():
		# such a great way of doing this!
		get_parent().get_parent().queue_free() # deleting the instantiated settings
		get_parent().get_parent().get_parent().button_container.show() # show the pause menu buttons again
	else:
		get_tree().change_scene_to_file("res://scenes/ui/menus/title_screen.tscn")
