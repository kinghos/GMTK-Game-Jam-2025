extends Control

const GAME_THEME = preload("res://assets/audio/music/game_theme.mp3")

func _ready() -> void:
	Music.play_music(GAME_THEME)

func _on_got_it_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
