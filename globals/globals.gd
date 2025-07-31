extends Node

var player: Player
var lasso: Lasso
var current_level: Node2D
var pause_menu: CanvasLayer = null

# Powerup values
var player_lasso_reach = 500
var lives: int
var stun_time: float = 1
var kick_distance: float = 150
enum POWERUPS {LassoSize, StunTime, KickDistance, ExtraLives, LassoReach, PlayerSpeed}
var POWERUP_LIST = ["Lasso Length", "Animal\nStun Time", "Kick Power", "Extra Lives", "Lasso Reach", "Player Speed"]
var KICK_MULT = {
	"Chicken": 1.2,
	"Cow": 0.8,
	"Sheep": 1
}
var time_left_on_timer: float

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
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
		POWERUPS.KickDistance:
			kick_distance += 20
		POWERUPS.ExtraLives:
			lives += 5
		POWERUPS.LassoReach:
			player_lasso_reach += 50
		POWERUPS.PlayerSpeed:
			player.speed += 30
		_:
			print("Invalid powerup")
