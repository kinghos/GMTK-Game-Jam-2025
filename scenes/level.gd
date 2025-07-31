extends Node2D

@onready var game_ui: CanvasLayer = $Overlay
@onready var start_countdown: CanvasLayer = $StartCountdown
@export var next_level: String
@onready var game_timer: Timer = $GameTimer

func _ready():
	Globals.current_level = self
	Globals.pause_menu = $PauseMenu

# Used for test level only
func _on_button_pressed() -> void:
	game_ui.trigger_powerups_menu()

func _process(_delta: float) -> void:
	Globals.time_elapsed = game_timer.wait_time - game_timer.time_left
	for pen: Pen in get_tree().get_nodes_in_group("Pens"):
		if !pen.is_full():
			return
	Globals.prevent_pause = true
	change_to_next_level()

func change_to_next_level():
	game_ui.trigger_powerups_menu()

func _on_game_ui_powerup_selected() -> void:
	get_tree().change_scene_to_file(next_level)
