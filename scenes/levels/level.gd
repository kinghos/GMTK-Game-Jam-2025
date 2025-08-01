extends Node2D

@onready var overlay: CanvasLayer = $Overlay
@onready var start_countdown: CanvasLayer = $StartCountdown
@export var next_level: String
@onready var game_timer: Timer = $GameTimer

func _ready():
	Globals.current_level = self
	Globals.pause_menu = $PauseMenu

func _process(_delta: float) -> void:
	Globals.time_elapsed = game_timer.wait_time - game_timer.time_left
	Globals.time_left = game_timer.time_left
	if Globals.time_left == 0:
		get_tree().paused = true
		Globals.prevent_pause = true
		overlay.trigger_game_over()
	for pen: Pen in get_tree().get_nodes_in_group("Pens"):
		if !pen.is_full():
			return
		pen.play_tick = true
	
	Globals.prevent_pause = true
	change_to_next_level()

func change_to_next_level():
	overlay.trigger_powerups_menu()

func _on_overlay_powerup_selected() -> void:
	get_tree().change_scene_to_file(next_level)
