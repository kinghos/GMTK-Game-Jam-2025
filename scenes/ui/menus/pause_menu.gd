extends CanvasLayer

var settings_menu_scene = preload("res://scenes/ui/menus/settings.tscn")

@onready var button_container = $Control/ButtonContainer

func _on_resume_button_pressed() -> void:
	Globals.toggle_pause_menu()

func _on_settings_button_pressed() -> void:
	var settings_instance = settings_menu_scene.instantiate()
	add_child(settings_instance)
	button_container.hide()

func _on_menu_button_pressed() -> void:
	Globals.toggle_pause_menu()
	get_tree().change_scene_to_file("res://scenes/ui/menus/title_screen.tscn")
