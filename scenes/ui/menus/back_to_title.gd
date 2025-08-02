extends Button

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_pressed() -> void:
	# such a great way of doing this!
	if get_tree().is_paused() and get_parent().name == "Settings":
		get_parent().hide()
		get_parent().get_parent().get_node("ButtonContainer").show()
	else:
		get_tree().change_scene_to_file("res://scenes/ui/menus/title_screen.tscn")
