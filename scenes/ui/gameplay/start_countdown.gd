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
		var tween = create_tween()
		tween.tween_property(get_parent().get_node("Player/Camera2D"), "zoom", Vector2(2, 2), animation_player.current_animation_length).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		await animation_player.animation_finished
		get_tree().paused = false
		hide()
		Globals.prevent_pause = false
		get_parent().in_countdown = false
	else:
		queue_free()
