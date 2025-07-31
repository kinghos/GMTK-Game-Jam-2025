extends Node2D

@onready var game_ui: CanvasLayer = $GameUI

func _ready():
	Globals.pause_menu = $PauseMenu

func _on_button_pressed() -> void:
	game_ui.trigger_powerups_menu()

func _process(delta: float) -> void:
	$GameUI/PlayerSpeed.text = "Speed: " + str(Globals.player.speed)
	$GameUI/StunTime.text = "StunTime: " + str(Globals.stun_time)
	$GameUI/KickDistance.text = "KickDistance: " + str(Globals.kick_distance)
	$GameUI/Lives.text = "Lives: " + str(Globals.lives)
	$GameUI/LassoReach.text = "LassoReach: " + str(Globals.player_lasso_reach)
	$GameUI/LassoSize.text = "LassoSize: " + str(Globals.lasso.MAX_LASSO_LENGTH)
