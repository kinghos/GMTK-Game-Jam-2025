extends Node

var player: Player
var lasso: Lasso
var player_lasso_reach = 200
var pause_menu: CanvasLayer = null
var lives: int
var stun_time: float = 1
var kick_distance: float = 50
enum POWERUPS {LassoSize, StunTime, KickDistance, ExtraLives, LassoReach, PlayerSpeed}
var POWERUP_LIST = ["LassoSize", "StunTime", "KickDistance", "ExtraLives", "LassoReach", "PlayerSpeed"]

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
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
			 
		
			
		
