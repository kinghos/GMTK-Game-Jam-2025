extends CanvasLayer

@onready var powerups: Control = $RoundEnd
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var powerup_options: HBoxContainer = $RoundEnd/ColorRect/PowerupOptions
@onready var time_left: Label = $RoundEnd/Box/TimeLeft
@onready var max_combo: Label = $RoundEnd/Box/MaxCombo
@onready var game_over_screen: Control = $GameOver

signal powerup_selected

func _ready() -> void:
	powerups.hide()

func trigger_powerups_menu():
	animation_player.play("Slide")
	randomise_powerup_options()
	get_tree().paused = true
	time_left.text = "Cleared in: %6.3f secs" % Globals.time_elapsed
	max_combo.text = "Max combo: %s" % Globals.max_combo

func close_powerups_menu():
	animation_player.play("Slide_out")
	await animation_player.animation_finished
	powerups.hide()
	get_tree().paused = false
	powerup_selected.emit()
	Globals.prevent_pause = false

func _on_option_pressed(option: String) -> void:
	var powerup_type = powerup_options.get_node(option).get_meta("powerup_type")
	Globals.apply_powerup(powerup_type)
	var powerup_name = Globals.POWERUP_LIST[powerup_type]
	Globals.powerup_selections[powerup_name] += 1
	close_powerups_menu()

func randomise_powerup_options():
	var powerups = Globals.POWERUP_LIST.duplicate()
	powerups.shuffle()
	powerups = powerups.slice(0, 3)
	for opt: Button in powerup_options.get_children():
		opt.text = powerups.pop_front()
		opt.icon = Globals.POWERUP_ICONS[opt.text]
		opt.set_meta("powerup_type", Globals.POWERUP_LIST.find(opt.text))

func trigger_game_over():
	game_over_screen.show()

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menus/title_screen.tscn")
