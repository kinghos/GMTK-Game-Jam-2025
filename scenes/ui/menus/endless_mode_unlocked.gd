extends Control


func _on_keep_going_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/endless.tscn")
	


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menus/title_screen.tscn")
