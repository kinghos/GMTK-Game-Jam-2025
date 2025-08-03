extends Node2D
class_name Level

@export var zoom_out_camera_level: float = 1.0

@onready var overlay: CanvasLayer = $Overlay
@onready var start_countdown: CanvasLayer = $StartCountdown
@export var next_level: String
@onready var game_timer: Timer = $GameTimer
@onready var hud: CanvasLayer = $HUD

const GAME_THEME = preload("res://assets/audio/music/game_theme.mp3")

var in_countdown: bool = false
var animals_on_screen: Array[BaseAnimal]

func _ready():
	Globals.current_level = self
	Globals.pause_menu = $PauseMenu
	Globals.wait_time = game_timer.wait_time
	Globals.game_timer = game_timer
	Globals.time_left = game_timer.time_left
	Globals.hud = hud
	Globals.time_elapsed = 0
	Globals.max_combo = 0
	
	Globals.uncaptured_cows = 0
	Globals.uncaptured_chickens = 0
	Globals.uncaptured_sheep = 0
	for animal_type in get_node("Animals").get_children():
		for animal in animal_type.get_children():
			if animal_type.name == "Cows":
				Globals.uncaptured_cows += 1
			elif animal_type.name == "Sheep":
				Globals.uncaptured_sheep += 1
			elif animal_type.name == "Chickens":
				Globals.uncaptured_chickens += 1
	
	var path = str(get_path())
	Globals.level_number = path[-1]
	if Globals.level_number == "s":
		Globals.level_number = "∞"
	Music.play_music(GAME_THEME)

func _process(delta: float) -> void:
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
	
