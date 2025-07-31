extends Node2D

@onready var game_ui: CanvasLayer = $GameUI
@onready var start_countdown: CanvasLayer = $StartCountdown
@export var next_level: String

func _ready():
	Globals.current_level = self
	Globals.pause_menu = $PauseMenu
	
func _on_button_pressed() -> void:
	game_ui.trigger_powerups_menu()

func _process(delta: float) -> void:
	for pen: Pen in get_tree().get_nodes_in_group("Pens"):
		if !pen.is_full():
			return
	change_to_next_level()

func change_to_next_level():
	game_ui.trigger_powerups_menu()

func _on_game_ui_powerup_selected() -> void:
	get_tree().change_scene_to_file(next_level)
