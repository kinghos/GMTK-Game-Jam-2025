extends CanvasLayer

@export var disabled: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if not disabled:
		get_parent().in_countdown = true
		Globals.prevent_pause = true
		get_tree().paused = true
		show()
		animation_player.play("countdown")
		await animation_player.animation_finished
		get_tree().paused = false
		hide()
		Globals.prevent_pause = false
		get_parent().in_countdown = false
	else:
		queue_free()
