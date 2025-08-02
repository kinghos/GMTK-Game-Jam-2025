extends Control

const MAIN_MENU_MUSIC = preload("res://assets/audio/music/intro+main menu.mp3")

func _ready() -> void:
	get_tree().paused = false
	Music.play_music(MAIN_MENU_MUSIC)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/gameplay/opening_cutscene.tscn")

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menus/settings.tscn")

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menus/credits.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_test_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/test_level.tscn")
