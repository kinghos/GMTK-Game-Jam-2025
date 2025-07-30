extends Control

const MAIN_MENU_MUSIC = preload("res://assets/audio/Main Menu.mp3")

func _ready() -> void:
	Music.play_music(MAIN_MENU_MUSIC)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test_scene.tscn")

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/settings.tscn")

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/credits.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
