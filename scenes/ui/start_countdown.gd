extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	get_tree().paused = true
	show()
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	hide()
