extends Node2D

@onready var game_ui: CanvasLayer = $GameUI

func _ready():
	Globals.current_level = self
	Globals.pause_menu = $PauseMenu

func _on_button_pressed() -> void:
	game_ui.trigger_powerups_menu()
