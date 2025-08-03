extends CanvasLayer

@onready var time_left: Label = $Control/TimeLeft
@onready var anim_marker: Control = $Control/AnimMarker
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var lasso_bar: HSlider = $Control/LassoBar
@onready var powerup_display: HBoxContainer = $Control/PowerupDisplay
@onready var level_display: Label = $Control/LevelDisplay
@onready var uncaptured_display: HBoxContainer = $Control/UncapturedDisplay

const TIMER_ANIM = preload("res://scenes/ui/gameplay/timer_anim.tscn")

func _process(_delta: float) -> void:
	if Globals.level_number == "∞":
		level_display.text = "Endless"
	else:
		level_display.text = "Level " + Globals.level_number
	lasso_bar.max_value = Globals.lasso.MAX_LASSO_LENGTH
	lasso_bar.value = Globals.lasso.MAX_LASSO_LENGTH - Globals.lasso.current_lasso_length
	time_left.text = "Time Left: %3.3fs" % Globals.time_left
	
	uncaptured_display.get_node("Sheep/Label").text = str(Globals.uncaptured_sheep)
	uncaptured_display.get_node("Cows/Label").text = str(Globals.uncaptured_cows)
	uncaptured_display.get_node("Chickens/Label").text = str(Globals.uncaptured_chickens)

func _ready() -> void:
	for powerup in Globals.powerup_selections:
		var powerup_count = Globals.powerup_selections[powerup]
		var icon: TextureRect = powerup_display.get_node(powerup)
		if powerup_count > 0:
			icon.material.set_shader_parameter("enabled", false)
		else:
			icon.material.set_shader_parameter("enabled", true)
		icon.get_node("Label").text = str(powerup_count)

func add_time(time_added: float):
	var timer_anim: HBoxContainer = TIMER_ANIM.instantiate()
	timer_anim.global_position = anim_marker.global_position
	timer_anim.get_node("Label").text = "+%s" % time_added
	anim_marker.add_child(timer_anim)
	timer_anim.get_node("AnimationPlayer").play("time_add")

func time_running_out():
	if animation_player.is_playing():
		return
	animation_player.play("time_running_out")

func reset_timer():
	animation_player.play("RESET")
