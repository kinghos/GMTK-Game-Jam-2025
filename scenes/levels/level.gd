extends Node2D
class_name Level

@onready var overlay: CanvasLayer = $Overlay
@onready var start_countdown: CanvasLayer = $StartCountdown
@export var next_level: String
@onready var game_timer: Timer = $GameTimer
@onready var hud: CanvasLayer = $HUD

var in_countdown: bool = false
var uncaptured_animal_number: int = 0
var animals_on_screen: Array[BaseAnimal]

func _ready():
	Globals.current_level = self
	Globals.pause_menu = $PauseMenu
	Globals.wait_time = game_timer.wait_time
	Globals.game_timer = game_timer
	Globals.hud = hud
	Globals.time_elapsed = 0
	Globals.max_combo = 0
	var path = str(get_path())
	Globals.level_number = path[-1]
	if Globals.level_number == "s":
		Globals.level_number = "∞"
	

func _process(delta: float) -> void:
	var new_value: int = 0
	for animal_type in get_node("Animals").get_children():
		for animal in animal_type.get_children():
			if !animal.in_pen:
				new_value += 1
	uncaptured_animal_number = new_value
	
	Globals.time_elapsed += delta
	Globals.time_left = game_timer.time_left
	
	if Globals.time_left == 0:
		get_tree().paused = true
		Globals.prevent_pause = true
		overlay.trigger_game_over()
	
	if Globals.time_left < 10:
		hud.time_running_out()
	else:
		hud.reset_timer()
	
	for pen: Pen in get_tree().get_nodes_in_group("Pens"):
		if !pen.is_full():
			return
	
	Globals.prevent_pause = true
	change_to_next_level()

func change_to_next_level():
	overlay.trigger_powerups_menu()

func _on_overlay_powerup_selected() -> void:
	get_tree().change_scene_to_file(next_level)
	
