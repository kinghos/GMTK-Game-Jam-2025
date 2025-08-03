extends Node

var player: Player
var game_timer: Timer
var lasso: Lasso
var current_level: Node2D
var level_number: String = "1"
var pause_menu: CanvasLayer = null
var hud: CanvasLayer
var endless_mult: float = 1

# Powerup values
var player_lasso_reach = 300
var stun_time: float = 1
var pen_kick_area: int = 200
enum POWERUPS {LassoSize, StunTime, PenKickArea, LassoReach, PlayerSpeed}
var POWERUP_LIST = ["Lasso Length", "Stun Time", "Pen Kick Area", "Lasso Reach", "Player Speed"]
var POWERUP_ICONS = {
	"Lasso Length": preload("res://assets/graphics/powerups/upgrades/lasso_length.png"),
	"Stun Time": preload("res://assets/graphics/powerups/upgrades/animal_stun_time.png"),
	"Pen Kick Area": preload("res://assets/graphics/powerups/upgrades/kick_power.png"),
	"Lasso Reach": preload("res://assets/graphics/powerups/upgrades/lasso_reach.png"),
	"Player Speed": preload("res://assets/graphics/powerups/upgrades/speed.png")
}
var POWERUP_INCREASES = {
	POWERUPS.LassoSize: 50,
	POWERUPS.StunTime: 0.5,
	POWERUPS.PenKickArea: 20,
	POWERUPS.LassoReach: 50,
	POWERUPS.PlayerSpeed: 30
}
var POWERUP_DESCRIPTIONS = {
	POWERUPS.LassoSize: "Increases the length of lasso that can be used to draw a loop",
	POWERUPS.StunTime: "Increases the time in seconds that an animal remains stunned",
	POWERUPS.PenKickArea: "Increases the radius of the area surrounding pens in which animals can be kicked",
	POWERUPS.LassoReach: "Increases how far away from your character you can start drawing your loop",
	POWERUPS.PlayerSpeed: "Increases your character's speed"
}

var max_combo: int = 0

var TIME_BONUSES = {
	"Chicken": 6,
	"Cow": 3,
	"Sheep": 4
}

var STUN_MULTS = {
	"Chicken": 1,
	"Cow": 0.7,
	"Sheep": 0.85
}

var cowboy_congratulations = ["Rootin' Tootin!", "Yeehaw!", "Cowabunga!", "Howdy!", "Yippee-ki-yay!", "He-yah!", "Hot Diggidy Damn!", "Well taxidermy my foot!"]
var seen_tutorial: bool = false
var unlocked_endless: bool = false
var wait_time: float
var time_elapsed: float
var time_left: float
var timer_mult: float = 1
var endless_rounds: int = 0
var prevent_pause: bool = false
var powerup_selections: Dictionary[String, int] = {
	"Lasso Length": 0,
	"Stun Time": 0,
	"Pen Kick Area": 0,
	"Lasso Reach": 0,
	"Player Speed": 0
}

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("Pause") and not prevent_pause:
		toggle_pause_menu()


func reset_game_state():
	for key in powerup_selections.keys():
		powerup_selections[key] = 0
	player_lasso_reach = 300
	stun_time = 1
	pen_kick_area = 200
	endless_rounds = 0
	endless_mult = 1

func toggle_pause_menu():
	if pause_menu:
		var is_visible = pause_menu.visible
		pause_menu.visible = not is_visible
		get_tree().paused = not is_visible

func apply_powerup(powerup: int):
	match powerup:
		POWERUPS.LassoSize:
			lasso.MAX_LASSO_LENGTH += POWERUP_INCREASES[powerup]
		POWERUPS.StunTime:
			stun_time += POWERUP_INCREASES[powerup]
		POWERUPS.PenKickArea:
			pen_kick_area += POWERUP_INCREASES[powerup]
		POWERUPS.LassoReach:
			player_lasso_reach += POWERUP_INCREASES[powerup]
		POWERUPS.PlayerSpeed:
			player.speed += POWERUP_INCREASES[powerup]
		_:
			print("Invalid powerup")

func get_current_powerup_value(powerup: int):
	match powerup:
		POWERUPS.LassoSize:
			return lasso.MAX_LASSO_LENGTH
		POWERUPS.StunTime:
			return stun_time
		POWERUPS.PenKickArea:
			return pen_kick_area
		POWERUPS.LassoReach:
			return player_lasso_reach
		POWERUPS.PlayerSpeed:
			return player.speed
		_:
			print("Invalid powerup")

func add_time(type: String, combo: int):
	var time_bonus = TIME_BONUSES[type]
	## Combo bonus is calculated as combo / 2, capping at 5 seconds
	#var combo_bonus = 0.0
	#if combo > 2:
		#combo_bonus = clampi(combo, 2, 10) / 2
	#var total = time_bonus + combo_bonus
	game_timer.stop()
	game_timer.wait_time = time_left + time_bonus
	game_timer.start()
	hud.add_time(time_bonus)

func update_timer():
	pass
