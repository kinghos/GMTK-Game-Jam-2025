extends CanvasLayer

@onready var time_left: Label = $Control/TimeLeft
@onready var powerup_container: HBoxContainer = $Control/PowerupContainer
const powerup_display = preload("res://scenes/powerup_display.tscn")


func _process(delta: float) -> void:
	time_left.text = "Time Left: %3.3fs" % Globals.time_left

func _ready() -> void:
	for powerup in Globals.powerup_selections:
		var new_powerup_display: TextureRect = powerup_display.instantiate()
		new_powerup_display.texture = Globals.POWERUP_ICONS[powerup]
		powerup_container.add_child(new_powerup_display)

	
