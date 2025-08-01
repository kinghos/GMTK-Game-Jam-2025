extends CanvasLayer

@onready var time_left: Label = $Control/TimeLeft
@onready var powerup_container: HBoxContainer = $Control/PowerupContainer
@onready var anim_marker: Control = $Control/AnimMarker
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const powerup_display = preload("res://scenes/ui/gameplay/powerup_display.tscn")
const TIMER_ANIM = preload("res://scenes/ui/gameplay/timer_anim.tscn")

func _process(_delta: float) -> void:
	time_left.text = "Time Left: %3.3fs" % Globals.time_left

func _ready() -> void:
	for powerup in Globals.powerup_selections:
		var new_powerup_display: TextureRect = powerup_display.instantiate()
		new_powerup_display.texture = Globals.POWERUP_ICONS[powerup]
		powerup_container.add_child(new_powerup_display)

func add_time(time_added: float):
	var timer_anim: HBoxContainer = TIMER_ANIM.instantiate()
	timer_anim.global_position = anim_marker.global_position
	timer_anim.get_node("Label").text = "+%s" % time_added
	anim_marker.add_child(timer_anim)
	timer_anim.get_node("AnimationPlayer").play("time_add")

func time_running_out():
	animation_player.play("time_running_out")

func reset_timer():
	animation_player.play("RESET")
