extends CanvasLayer

@onready var powerups: Control = $Powerups
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	powerups.hide()

func trigger_powerups_menu():
	animation_player.play("Slide")
	get_tree().paused = true

func close_powerups_menu():
	animation_player.play_backwards("Slide")
	powerups.hide()
	get_tree().paused = false

func _on_option_pressed(option: int) -> void:
	print("Option ", option, " pressed")
	close_powerups_menu()
