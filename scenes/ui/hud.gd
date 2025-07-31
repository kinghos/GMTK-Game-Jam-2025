extends CanvasLayer

@onready var time_left: Label = $Control/TimeLeft
@onready var powerup_container: HBoxContainer = $Control/PowerupContainer

func _process(delta: float) -> void:
	time_left.text = "Time Left: %3.3fs" % Globals.time_elapsed


func _on_overlay_send_powerup_display(new_powerup_display: TextureRect) -> void:
	powerup_container.add_child(new_powerup_display)
