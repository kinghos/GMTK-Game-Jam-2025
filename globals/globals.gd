extends Node

var player: Player
var lasso: Lasso
var current_level: Node2D
var pause_menu: CanvasLayer = null

# Powerup values
var player_lasso_reach = 500
var lives: int
var stun_time: float = 1
var pen_kick_area: float = 250
enum POWERUPS {LassoSize, StunTime, PenKickArea, LassoReach, PlayerSpeed}
var POWERUP_LIST = ["Lasso Length", "Animal\nStun Time", "Pen Kick Area", "Lasso Reach", "Player Speed"]
var POWERUP_ICONS = {
	"Lasso Length": preload("res://assets/graphics/powerups/lasso_length.png"),
	"Animal\nStun Time": preload("res://assets/graphics/powerups/animal_stun_time.png"),
	"Pen Kick Area": preload("res://assets/graphics/powerups/kick_power.png"),
	"Lasso Reach": preload("res://assets/graphics/powerups/lasso_reach.png"),
	"Player Speed": preload("res://assets/graphics/powerups/speed.png")
}

var KICK_MULT = {
	"Chicken": 1.2,
	"Cow": 0.8,
	"Sheep": 1
}
var cowboy_congratulations = ["Rootin' Tootin!", "Yeehaw!", "Cowabunga!", "Howdy!", "Yippee-ki-yay!", "He-yah!", "Hot Diggidy Damn!"]

var time_elapsed: float
var time_left: float
var prevent_pause: bool = false

var powerup_selections: Array[String]

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("Pause") and not prevent_pause:
		toggle_pause_menu()

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
