extends CharacterBody2D
class_name Player


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var lasso_start: Marker2D = $LassoStart
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var animals_in_range: Array[BaseAnimal]

func _ready() -> void:
	Globals.player = self
	rotation = 0

func _process(_delta: float) -> void:
	if get_global_mouse_position().x > global_position.x:
		if animated_sprite_2d.flip_h:
			lasso_start.position = Vector2(26, 16)
		else:
			lasso_start.position = Vector2(22, 12)
	if get_global_mouse_position().x < global_position.x:
		if animated_sprite_2d.flip_h:
			lasso_start.position = Vector2(-18, 12)
		else:
			lasso_start.position = Vector2(-22, 16)

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	if direction.x < 0:
		animated_sprite_2d.flip_h = true
	elif direction.x > 0:
		animated_sprite_2d.flip_h = false
	velocity = Globals.player_speed * direction
	if !(animated_sprite_2d.animation == "kick" and animated_sprite_2d.is_playing()):
		if velocity != Vector2.ZERO:
			animated_sprite_2d.play("run")
			if !animation_player.is_playing():
				animation_player.play("run"	)
		else:
			animated_sprite_2d.play("idle")
			animation_player.play("RESET")
			animation_player.stop()
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Kick"):
		for animal in animals_in_range:
			if !animal.being_kicked and animal.is_in_kick_area:
				animated_sprite_2d.play("kick")
				animal.being_kicked = true  # necessary so that combo count doesn't reset, since it would only be set to true in kick() AFTER the stun timer timeout
				animal.stun_timer.stop()
				animal._on_stun_timer_timeout()
				animal.kick()
				audio_stream_player.play()
