extends CanvasLayer

@onready var powerups: Control = $RoundEnd
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var powerup_options: HBoxContainer = $RoundEnd/ColorRect/PowerupOptions
@onready var time_left: Label = $RoundEnd/TimeLeft

signal powerup_selected

func _ready() -> void:
	powerups.hide()

func _process(_delta: float) -> void:
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
	time_left.text = "Cleared in:\n%6.3f seconds" % Globals.time_left_on_timer

func close_powerups_menu():
	animation_player.play("Slide_out")
	await animation_player.animation_finished
	powerups.hide()
	get_tree().paused = false
	powerup_selected.emit()
	Globals.prevent_pause = false

func _on_option_pressed(option: String) -> void:
	print(option, " pressed")
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
	
