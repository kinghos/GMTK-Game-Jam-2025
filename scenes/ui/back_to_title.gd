extends TextureButton

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")
