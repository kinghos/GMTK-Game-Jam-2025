extends CanvasLayer

@onready var powerups: Control = $Powerups
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var powerup_options: HBoxContainer = $Powerups/ColorRect/PowerupOptions

func _ready() -> void:
	powerups.hide()

func _process(delta: float) -> void:
	$DebugValues/PlayerSpeed.text = "Speed: " + str(Globals.player.speed)
	$DebugValues/StunTime.text = "StunTime: " + str(Globals.stun_time)
	$DebugValues/KickDistance.text = "Kick Distance: " + str(Globals.kick_distance)
	$DebugValues/Lives.text = "Lives: " + str(Globals.lives)
	$DebugValues/LassoReach.text = "Lasso Reach: " + str(Globals.player_lasso_reach)
	$DebugValues/LassoSize.text = "Lasso Size: " + str(Globals.lasso.MAX_LASSO_LENGTH)

func trigger_powerups_menu():
	animation_player.play("Slide")
	randomise_powerup_options()
	get_tree().paused = true

func close_powerups_menu():
	animation_player.play_backwards("Slide")
	await animation_player.animation_finished
	powerups.hide()
	get_tree().paused = false

func _on_option_pressed(option: String) -> void:
	print("Option ", option, " pressed")
	var powerup_type = powerup_options.get_node(option).get_meta("powerup_type")
	Globals.apply_powerup(powerup_type)
	close_powerups_menu()

func randomise_powerup_options():
	var powerups = Globals.POWERUP_LIST.duplicate()
	powerups.shuffle()
	powerups = powerups.slice(0, 3)
	for opt: Button in powerup_options.get_children():
		opt.text = powerups.pop_front()
		opt.set_meta("powerup_type", Globals.POWERUP_LIST.find(opt.text))
	
