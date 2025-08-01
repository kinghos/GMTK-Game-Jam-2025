extends Node

var player: Player
var game_timer: Timer
var lasso: Lasso
var current_level: Node2D
var pause_menu: CanvasLayer = null
var hud: CanvasLayer

# Powerup values
var player_lasso_reach = 500
var stun_time: float = 1
var pen_kick_area: float = 250
enum POWERUPS {LassoSize, StunTime, PenKickArea, LassoReach, PlayerSpeed}
var POWERUP_LIST = ["Lasso Length", "Animal\nStun Time", "Pen Kick Area", "Lasso Reach", "Player Speed"]
var POWERUP_ICONS = {
	"Lasso Length": preload("res://assets/graphics/powerups/lasso_length.png"),
	"Animal\nStun Time": preload("res://assets/graphics/powerups/lasso_reach.png"),
	"Pen Kick Area": preload("res://assets/graphics/powerups/kick_power.png"),
	"Lasso Reach": preload("res://assets/graphics/powerups/lasso_reach.png"),
	"Player Speed": preload("res://assets/graphics/powerups/speed.png")
}

var max_combo: int = 0

var TIME_BONUSES = {
	"Chicken": 5,
	"Cow": 2,
	"Sheep": 3
}

var cowboy_congratulations = ["Rootin' Tootin!", "Yeehaw!", "Cowabunga!", "Howdy!", "Yippee-ki-yay!", "He-yah!", "Hot Diggidy Damn!", "Well taxidermy my foot!"]

var wait_time: float
var time_elapsed: float
var time_left: float
var prevent_pause: bool = false
var initial_time: float = 0
var powerup_selections: Array[String]

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("Pause") and not prevent_pause:
		toggle_pause_menu()
	if time_elapsed > 1 and time_left == 0:
		powerup_selections.clear()
		player_lasso_reach = 500
		lasso.MAX_LASSO_LENGTH = 600
		stun_time = 1
		pen_kick_area = 250
		player.speed = 400
		max_combo = 0

func toggle_pause_menu():
	if pause_menu:
		var is_visible = pause_menu.visible
		pause_menu.visible = not is_visible
		get_tree().paused = not is_visible

func apply_powerup(powerup: int):
	match powerup:
		POWERUPS.LassoSize:
			lasso.MAX_LASSO_LENGTH += 50
		POWERUPS.StunTime:
			stun_time += 0.5
		POWERUPS.PenKickArea:
			pen_kick_area += 20
		POWERUPS.LassoReach:
			player_lasso_reach += 50
		POWERUPS.PlayerSpeed:
			player.speed += 30
		_:
			print("Invalid powerup")

func add_time(type: String, combo: int):
	var time_bonus = TIME_BONUSES[type]
	# Combo bonus is calculated as combo / 2, capping at 5 seconds
	var combo_bonus = 0.0
	if combo > 2:
		combo_bonus = clampi(combo, 2, 10) / 2
	var total = time_bonus + combo_bonus
	game_timer.stop()
	game_timer.wait_time = time_left + total
	game_timer.start()
	hud.add_time(total)
