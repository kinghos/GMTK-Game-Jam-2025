extends Control


func _on_got_it_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
