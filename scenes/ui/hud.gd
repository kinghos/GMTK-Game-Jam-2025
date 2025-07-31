extends CanvasLayer

@onready var time_left: Label = $Control/TimeLeft

func _process(delta: float) -> void:
	time_left.text = "Time Left: %3.3fs" % Globals.time_elapsed
